class PostsController < ApplicationController
    before_action :authenticate_user, only: [ :create, :show, :update, :delete ]
    before_action :set_post, only: [ :show, :update, :delete ]

    def index
        @posts = Post.allrender json: {result: true, posts: @posts}, status: :ok
    end

    def create
        @post = current_user.posts.create(post_param)
        if @post.save
            render json: {result: true, posts: @post}, status: :created    
        else
            render json: {result: false, posts: @post.errors}, status: :unprocessable_entity
        end
    end

    def show
        @post = set_post
        render json: {result: true, post: @post}, :include => {:user=>{:only=>:username}}
    end

    def update
        if current_user
            @post.update(post_param)
            render json: {result: true, post: @post}, status: :created
        else
            render json: {msg: "You can't access!"}, status: :unprocessable_entity
        end
    end

    def show_by_userid
        @user = User.find(params[:id])
        @post = @user.posts
        render json: {posts: @post}
    end

    def delete
        if current_user
            @post.destroy
            render json: {msg: "Delete post data success!"}
        else
            render json: {msg: "You can't access!"}
        end
    end

    private
    def post_param
        params.require(:post).permit(:title, :description)
    end

    def set_post
        @post = Post.find(params[:id])
    end
end
