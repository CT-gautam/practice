class PostsController < ApplicationController
	
	http_basic_authenticate_with name: "gautam", password: "password", except: [:index, :show]

	def index
		@post = Post.all
	end

	def new
		@post = Post.new
	end

	def edit
  	@post = Post.find(params[:id])
	end

	def update
  @post = Post.find(params[:id])
 
  	if @post.update(post_params)
    	redirect_to @post
  	else
    	render 'edit'
  	end
	end

	def destroy
 		@post = Post.find(params[:id])
  	@post.destroy
 
  	redirect_to posts_path
	end
	
	def show
		@post = Post.find(params[:id])
	end
	
	def create
		# render plain: params[:post].inspect
		@post = Post.new(post_params)
			if @post.save
				redirect_to @post
			else
				render 'new'
				# render 'posts/new'
				# render new_post_path
			end
	end

	private def post_params
		params.require(:post).permit(:title, :body)
	end
end
