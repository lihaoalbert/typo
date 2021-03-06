class Admin::PostTypesController < Admin::BaseController
  layout 'administration'

  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end
  def new; new_or_edit ; end
  def edit; new_or_edit;  end

  def destroy
    @pt = PostType.find(params[:id])
    if request.post?
      Article.find(:all, :conditions => ["post_type = ?", @pt.permalink]).each do |article|
        article.post_type = 'read'
        article.save
      end
      @pt.destroy
      redirect_to :action => 'index'
    end
  end

  private

  def new_or_edit
    @post_types = PostType.find(:all)
    @post_type = case params[:id]
                when nil
                  PostType.new
                else
                  PostType.find(params[:id])
                end
    @post_type.attributes = params[:post_type]
    if request.post?
      save_post_type
      return
    end
    render 'new'
  end

  def save_post_type
    if @post_type.save!
      flash[:notice] = _('Post Type was successfully saved.')
    else
      flash[:error] = _('Post Type could not be saved.')
    end
    redirect_to :action => 'index'
  end

end
