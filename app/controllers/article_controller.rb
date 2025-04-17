class ArticleController < ApplicationController
  def new
  end

  def addArticle
    @article = Article.new(params.require(:article).permit(:title, :description))
    @article.user_id=session[:user_id]
    @article.save
    redirect_to "/home"
  end
  def edit
    @article=Article.find(params[:id])
  end

  def home
    if session[:user_id]
      @user = User.find_by(id: session[:user_id]) # safer than .find
    end

    @articles = Article.all.paginate(page: params[:page], per_page: 4)
  end

  def logout
    session[:user_id]=nil
    redirect_to "/login"
  end

  def delete
    @article=Article.find(params[:id])
    @article.destroy
    redirect_to "/home"
  end

  def updateArticle
    @article=Article.find(params[:id])
    @article.update(params.require(:article).permit(:title, :description))
    redirect_to "/home"
  end


  def search
    if params[:query].present?
      keyword = "%#{params[:query].downcase}%"
      @articles = Article.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", keyword, keyword).paginate(page: params[:page], per_page: 4)
      @user = User.find(session[:user_id]) if session[:user_id]
      flash.now[:notice] = "Showing results for: #{params[:query]}"
      render :home
    else
      redirect_to home_path, alert: "Please enter a search term."
    end
  end
end
