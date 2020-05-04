class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  # 商品詳細ページ (田村)
  def show
  end

  # トップページ・商品一覧ページ
  def index
  end

  # 商品出品ページ
  def new
    @item = Item.new
    @item.item_images.new
  end

  # 商品出品機能
  def create
    @item = Item.new(item_params)
    if @item.save!
      redirect_to root_path
    else
      render :new
    end
  end

  # 商品情報更新ページ (田村)
  def edit
    if user_signed_in? && current_user.id != @item.user_id
      redirect_to item_path
    end
  end

  # 商品情報更新機能 (田村)
  def update
    if @item.update(item_params)
      redirect_to item_path
    else
      render :edit
    end
  end

  # 商品削除機能
  def destroy
    if user_signed_in? && current_user.id == @item.user_id
      @item.destroy
    else
      redirect_to item_path
    end
  end

  private
  # 出品時にフォーム入力されるデータ
  def item_params
    params.require(:item).permit(:name, 
                                   :price, 
                                   :status_id, 
                                   :brand, 
                                   :shipping_fee_id, 
                                   :shipping_method_id, 
                                   :owners_area_id, 
                                   :arrival_date_id, 
                                   :explain, 
                                   :a_category_id, 
                                   :buyer_id,
                                   item_images_attributes: [:image]
                                   )
                                    #  .merge(user_id: current_user.id)をユーザー登録機能が出来たら追記する。 永井
  end


  def set_item
    @item = Item.find(params[:id])
    @name = @item.name
    @price = @item.price
    @brand = @item.brand
    @explain = @item.explain

    # active_hashを利用
    @status = @item.status.name
    @shipping_fee = @item.shipping_fee.name
    @shipping_method = @item.shipping_method.name 
    @owners_area = @item.owners_area.name
    @arrival_date = @item.arrival_date.name

    # 仮
    @category = @item.a_category.name
    @user = User.find(@item.user_id).nickname
    # @buyer =

    # 配列なのでs付けておく
    @imgs = ItemImage.where(item_id: params[:id]) 
  end

end