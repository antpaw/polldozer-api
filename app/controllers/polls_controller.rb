class PollsController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :set_poll, only: [:show, :edit, :update, :vote, :destroy]
  layout false

  # GET /polls/1
  # GET /polls/1.json
  def show
    calculate_poll
  end

  # GET /polls/new
  def new
    @poll = Poll.new
  end

  # POST /polls
  # POST /polls.json
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

  # PATCH/PUT /polls/1
  # PATCH/PUT /polls/1.json
  def update
    respond_to do |format|
      if @poll.has_token?(params[:token]) && @poll.update(poll_params)
        calculate_poll
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: {errors: full_message_errors}, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /polls/1/vote
  # PATCH/PUT /polls/1/vote.json
  def vote
    respond_to do |format|
      if @poll.vote_answer(params[:answer_id], request.remote_ip)
        calculate_poll
        format.html { redirect_to @poll, notice: 'Vote was counted successfully.' }
        format.json { render :show, status: :ok, location: @poll }
      else
        format.html { render :edit }
        format.json { render json: {errors: full_message_errors}, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.json
  def destroy
    respond_to do |format|
      if @poll.has_token?(params[:token])
        @poll.destroy
        format.html { redirect_to polls_url, notice: 'Poll was successfully destroyed.' }
        format.json { head :no_content }
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
      @poll.set_ip_has_voted(request.remote_ip)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poll_params
      params.fetch(:poll, {}).permit(:title)
    end
end
