class CommentsController < ApplicationController
	
	http_basic_authenticate_with name: "gautam", password: "password", only: :destroy

	def create
		@post = Post.find(params[:post_id])
		@comment = @post.comments.create(comment_params)
		redirect_to post_path(@post)
	end

	# def update
	# 	@post = Post.find(params[:post_id])
	# 	@comment = @post.comments.find(params[:id])
	# 	if @comment.update(comment_params)
 #  		redirect_to posts_path(@post)
  		
	# end
		# def update
  # @post = Post.find(params[:id])
 
 #  	if @post.update(post_params)
 #    	redirect_to @post
 #  	else
 #    	render 'edit'
 #  	end
	# end

	def destroy
		@post = Post.find(params[:post_id])
		@comment = @post.comments.find(params[:id])
		@comment.destroy
  	redirect_to posts_path(@post)
	end

	private def comment_params
		params.require(:comment).permit(:commenter, :body)
	end
end
