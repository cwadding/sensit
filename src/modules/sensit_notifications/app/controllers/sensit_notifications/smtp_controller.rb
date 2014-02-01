class Settings::SmtpController < SettingsController
  # before_filter :authenticate_user!
  # authorize_resource

  # GET /settings/smtps
  # GET /settings/smtps.json
  def show
    @smtp = Smtp.new
  end

  # POST /settings/smtps
  # POST /settings/smtps.json
  def create
    verb = view_context.past_tensify(Smtp.exists? ? "create" : "update")
    @smtp = Smtp.new(params[:smtp])
    respond_to do |format|
      if @smtp.save
        format.html { redirect_to smtp_url, notice: I18n.t("flash.notice.one", model: Smtp.model_name.human, verb: verb) }
      else
        format.html { render action: "show" }
      end
    end
  end


  def test
    @smtp = Smtp.new
    respond_to do |format|
      if UserMailer.test(params[:to_address]).deliver
        format.html { render "show", notice: "Email succussfully sent."}
      else
        format.html { render "show", notice: "Unable to send email through SMTP settings."}
      end
    end
  end
  
  # DELETE /settings/smtps
  # DELETE /settings/smtps.json
  def destroy
    verb = view_context.past_tensify("destroy")
    if Smtp.destroy
      flash[:notice] = I18n.t("flash.notice.one", model: Smtp.model_name.human, verb: verb)
    else
      flash[:error] = I18n.t("flash.error", :model => Smtp.model_name.human, :verb => verb)
    end

    respond_to do |format|
      format.html { redirect_to smtp_url }
    end
  end
end
