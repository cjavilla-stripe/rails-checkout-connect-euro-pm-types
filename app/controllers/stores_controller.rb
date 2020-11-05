class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  # GET /stores
  # GET /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new

  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(store_params)

    # Create Stripe Account
    stripe_account = Stripe::Account.create(
      type: 'standard',
      country: @store.country,
      business_profile: {
        name: @store.name,
      },
      settings: {
        branding: {
          primary_color: "##{SecureRandom.hex(3)}"
        }
      }
    )
    @store.stripe_account_id = stripe_account.id

    # Create Stripe AccountLink
    account_link = Stripe::AccountLink.create(
      account: stripe_account.id,
      type: 'account_onboarding',
      refresh_url: stores_url,
      return_url: stores_url,
    )

    # Redirect
    respond_to do |format|
      if @store.save
        format.html { redirect_to account_link.url }
        format.json { render json: account_link }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  # PATCH/PUT /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
      @payment_method_types = {
        'Bancontact': 'bancontact',
        'Card': 'card',
        'EPS': 'eps',
        'giropay': 'giropay',
        'iDEAL': 'ideal',
        'P24': 'p24',
        'SEPA Debit': 'sepa_debit',
        'Sofort': 'sofort',
      }
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(
        :name,
        :country,
        enabled_pm_types: []
      )
    end
end
