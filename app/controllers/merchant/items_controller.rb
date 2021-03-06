class Merchant::ItemsController < Merchant::BaseController
  def index
    @merchant = Merchant.find_by(id: current_user.merchant_id)
  end

  def new;end

  def create
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    @item = @merchant.items.create(item_params)
    if @item.save
      redirect_to '/merchant/items'
      flash[:success] = "#{@item.name} has been added."
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def change_status
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    item = Item.find(params[:item_id])
    if item.activation_status == 'Deactivated'
      item.update(activation_status: 'Activated')
      flash[:success] = "#{item.name} was activated."
    else
      item.update(activation_status: 'Deactivated')
      flash[:success] = "#{item.name} was deactivated."
    end
    redirect_to '/merchant/items'
  end

  def edit
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    @item = @merchant.items.find(params[:item_id])
  end

  def update
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    @item = @merchant.items.find(params[:item_id])
    @item.update(item_params)
    if @item.save
      flash[:success] = "#{@item.name} has been updated."
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @merchant = Merchant.find_by(id: current_user.merchant_id)
    item = @merchant.items.find(params[:item_id])
    Item.destroy(params[:item_id])
    redirect_to '/merchant/items'
    flash[:success] = "#{item.name} was deleted."
  end

  private

  def item_params
    params.permit(:name, :description, :image, :price, :inventory)
  end
end
