class TweetsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]

  def new
    @tweet = Tweet.new
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def index
    @tweets = Tweet.all

  # 検索ワードがある場合
    if params[:search].present?
      search = params[:search]
      @tweets = @tweets.where("song LIKE ? OR artist LIKE ?", "%#{search}%", "%#{search}%")
    end

  # 単一ジャンル選択（セレクトボックス）
    if params[:tag_name].present?
      @tweets = @tweets.joins(:tags).where(tags: { name: params[:tag_name] }).distinct
    end

  # 複数ジャンル選択（チェックボックス）
    if params[:tag_ids].present?
      selected_tags = params[:tag_ids].select { |_, v| v == "1" }.keys
      @tweets = Tweet.joins(:tags).where(tags: { name: selected_tags }).distinct
    end
  end



  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id

    if @tweet.save
      if params[:tweet][:tag_ids]
        tag_ids = Array(params[:tweet][:tag_ids])
        @tweet.tag_ids = tag_ids.reject(&:blank?)
      end
      redirect_to tweets_path  # ← これがなかった！
    else
      render :new
    end
  end




    def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    tweet = Tweet.find(params[:id])
    if tweet.update(tweet_params)
      redirect_to :action => "show", :id => tweet.id
    else
      redirect_to :action => "new"
    end
  end

  # 追加ここから
  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to action: :index
  end

  private
  def tweet_params
    params.require(:tweet).permit(:song, :artist, :opinion, :body, tag_ids: [])
  end
end
