class PollsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_poll, only: [:show, :edit, :vote]
  layout false

  # GET /polls/1
  # GET /api/v1/polls/1.json
  def show
    calculate_poll
    manage_vote
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # POST /polls
  # POST /api/v1/polls.json
  def create
    @poll = Poll.new(title: params[:poll_title])
    @poll.set_valid_until_from_offset(params[:date_offset])
    @poll.set_answers(params[:answer_titles])
    respond_to do |format|
      if @poll.save
        calculate_poll
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        format.json { render :show, status: :created, location: @poll }
      else
        format.html { render :new }
        format.json { render json: {errors: full_message_errors}, status: :unprocessable_entity }
      end
    end
  end

  # POST/PATCH/PUT /polls/1/vote
  # POST/PATCH/PUT /api/v1/polls/1/vote.json
  def vote
    respond_to do |format|
      if answer = @poll.vote_answer(params[:answer_id], client_has_voted?)
        @vote = Vote.new(
          poll_id: @poll.id,
          answer_id: answer.id,
          ip_address: request.remote_ip
        )
        @vote.save
        calculate_poll
        @poll.set_users_vote_for_answer(@vote.answer_id)
        format.html { redirect_to @poll, notice: 'Vote was counted successfully.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: {errors: full_message_errors}, status: :unprocessable_entity }
      end
    end
  end

  private
    def full_message_errors
      @poll.errors.full_messages
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_poll
      @poll = Poll.find(params[:id])
    end

    def calculate_poll
      @poll.set_answers_percent
      @poll.set_answers_status
      @poll.set_ip_has_voted(client_has_voted?)
    end

    def manage_vote
      # it might be a good solution to store the answer_id so we dont have to query Vote, but it's no needed right now
      # if params[:users_answer_id]
      #   @poll.set_users_vote_for_answer(params[:users_answer_id])
      # end
      if find_vote
        @poll.set_users_vote_for_answer(@vote.answer_id)
      end
    end

    def find_vote
      vote_id = if params[:vote_id]
        params[:vote_id]
      else
        cookies["poll_#{@poll.id}".to_sym]
      end
      return  unless vote_id
      @vote = Vote.where(id: vote_id).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.fetch(:poll, {}).permit(:title)
    end

    def client_has_voted?
      return true if @vote
      # `users_answer_id` performance optimization
      # return true if params[:users_answer_id]
      return true if find_vote
      return true if request.remote_ip.blank?
      Vote.ip_has_too_many_vote_in_poll(request.remote_ip, @poll.id)
    end
end
