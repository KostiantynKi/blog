class ArticlesController < ApplicationController
  skip_before_action :authenticate, only: [:index, :show]

  def index
    if !!params["edited"] #   == "true"
      if @user
        articles = Article.where(user_id: @user.id) #  "user_id == #{@user.id}"
      else
        articles = Article.all
      end
    else
      articles = Article.all
    end
    render json: articles.to_json(:only => ["title", "description", "user_id", "id"])
  end

  def show
    @article = Article.find(params[:id])
    render json: @article.to_json(:only => ["title", "body", "user_id", "id", "image"])
  end

  def create
    puts params
    article = Article.new(articles_params)
    article.user = @user #  Привязали создание новой статьи к текущему юзеру

    if article.save
      render json: { status: '200', body: article }
    else
      render json: { status: '400', body: article }
    end
  end

  def update
    article = Article.find(params[:id])

    if article.user_id == @user.id.to_s
      if article.update(articles_params)
        render json: { status: '200', body: article }
      else
        render json: { status: '400', body: article }
      end
    else
      render json: { status: '422', body: "Not Correct User Authorization" }
    end
  end

  def destroy
    article = Article.find(params[:id])

    if article.user_id == @user.id.to_s
      if article.destroy
        render json: { id: (params[:id]), result: "page deleted" }
      else
        render json: { status: '400', body: "page not deleted" }
      end
    else
      render json: { status: '422', body: "Not Correct User Authorization" }
    end
  end

  private def articles_params
    # params - объект класса, отображающий запрос от клиента
    # permit - указывем то, что хотим получить
    params.permit(:id, :title, :body, :description, :image)
  end

end

