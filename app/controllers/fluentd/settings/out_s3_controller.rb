class Fluentd::Settings::OutS3Controller < ApplicationController
  before_action :login_required
  before_action :find_fluentd

  def show
    @setting = Fluentd::Setting::OutS3.new({
      s3_endpoint: "s3-us-west-1.amazonaws.com",
      buffer_path: "/var/log/fluent/s3",
    })
  end

  def finish
    @setting = Fluentd::Setting::OutS3.new(setting_params)
    unless @setting.valid?
      return render "show"
    end

    @fluentd.agent.config_append @setting.to_conf
    if @fluentd.agent.running?
      unless @fluentd.agent.restart
        @setting.errors.add(:base, @fluentd.agent.log_tail(1).first)
        return render "show"
      end
    end
    redirect_to fluentd_setting_path(@fluentd)
  end

  private

  def setting_params
    params.require(:fluentd_setting_out_s3).permit(*Fluentd::Setting::OutS3::KEYS)
  end

end
