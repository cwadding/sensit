class Settings::EmailGroupsController < SettingsController
  # before_filter :authenticate_user!
  # authorize_resource
  # GET /settings/emails
  # GET /settings/emails.json
  def index
    @search = EmailGroup.ransack(params[:q])
    @email_groups = @search.result(:distinct => true).page(params[:page]).per(params[:per])
    
    respond_to do |format|
      format.html
      format.js { render "base/index", :locals => {items: @email_groups, search: @search }}
    end
  end

  # GET /settings/emails/new
  # GET /settings/emails/new.json
  def new
    @email_group = EmailGroup.new
  end

  # GET /settings/emails/1
  def show
    @email_group = EmailGroup.find(params[:id])
  end

  # POST /settings/emails
  # POST /settings/emails.json
  def create
    @email_group = EmailGroup.new(params[:email_group])

    respond_to do |format|
      if @email_group.save
        flash[:notice] = flash_notice(@email_group, "create")
        format.html { redirect_to email_groups_url }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /settings/emails/1
  # PUT /settings/emails/1.json
  def update
    @email_group = EmailGroup.find(params[:id])

    respond_to do |format|
      if @email_group.update_attributes(params[:email_group])
        flash[:notice] = flash_notice(@email_group, "update")
        format.html { redirect_to email_groups_url }
      else
        format.html { render action: "show" }
      end
    end
  end
  
  # PUT /settings/emails/multiple
  # PUT /settings/emails/multiple.json
  def multiple
    @email_groups = EmailGroup.find(params[:email_group_ids])
    if params.has_key?(:remove)
        @email_groups.map(&:destroy)
        flash[:notice] = flash_notice(@email_groups, "destroy")
    end 
    respond_to do |format|
      format.html { redirect_to email_groups_url }
    end
  end

  # DELETE /settings/emails/1
  # DELETE /settings/emails/1.json
  def destroy
    @email_group = EmailGroup.find(params[:id])
    @email_group.destroy

    respond_to do |format|
      flash[:notice] = flash_notice(@email_group, "destroy")
      format.html { redirect_to email_groups_url }
      format.js { render "base/destroy", :locals => {item: @email_group }}
    end
  end
end
