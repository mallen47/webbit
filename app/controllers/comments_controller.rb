class CommentsController < ApplicationController
	
	before_action :authenticate_user!
	before_action :set_comment, only: [:edit, :update, :show, :destroy]
	before_action :set_submission

	def new
	end

	def create
		@comment = @submission.comments.create(
			params[:comment].permit(:reply, :submission_id))
		@comment.user_id = current_user.id

		respond_to do |format|
			if @comment.save
				format.html { redirect_to submission_path(@submission)}
				format.js
			else
				format.html { redirect_to submission_path(@submission), 
					            notice: "Your comments were not saved. Please try again."}
				format.js
			end
		end
	end

	def edit
	end

	def update
		respond_to do |format|
			if @comment.update(comment_params)
				format.html { redirect_to submission_path(@submission), 
					            notice: "Comment was successfully updated."}
			else
				format.html { render :edit }
				format.json { render json: @comment_errors, 
					            status: unprocessable_entity }
			end
		end
	end

	def destroy
		@comment.destroy
		redirect_to submission_path(@submission)
	end

	private

		def set_submission
			@submission = Submission.find(params[:submission_id])
			redirect_to submission_path(@submission)
		end

		def set_comment
			@comment = Comment.find(params[:id])
		end

		def comment_params
			params.require(:comment).permit(:reply)
		end

end