class DigitalObjectsController < CrudController

  self.permitted_attrs = [:digital_object_id,:home_repository]

    # Never trust parameters from the scary internet, only allow the white list through.
    def digital_object_params
      params.require(:digital_object).permit(:digital_object_id,:home_repository)
    end
end
