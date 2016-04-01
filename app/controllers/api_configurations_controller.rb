class ApiConfigurationsController < ApplicationController
	before_action :set_api_configuration, only: [:edit, :update]
	layout "admin"

	# GET /api_configurations/1/edit
	def edit
	end

	# PATCH/PUT /api_configurations/1
	# PATCH/PUT /api_configurations/1.json
	def update
		respond_to do |format|
			if @api_configuration.update(api_configuration_params)
				format.html { redirect_to api_configurations_path, notice: 'Api configuration was successfully updated.' }
				format.json { render :show, status: :ok, location: @api_configuration }
			else
				format.html { render :edit }
				format.json { render json: @api_configuration.errors, status: :unprocessable_entity }
			end
		end
	end

	private
	def set_api_configuration
		@api_configuration = ApiConfiguration.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def api_configuration_params
		params.require(:api_configuration).permit(:client_id, :client_secret)
	end
end
