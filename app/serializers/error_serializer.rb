class ErrorSerializer
  def self.no_found_merchant(search)
    {
      'errors': [
        {
          "status": "NOT FOUND",
          "message": "No merchants found by the name #{search}",
          "code": 404
        }
      ]
    }
  end

  def self.invalid_params
    {
      'errors': [
        {
          "status": "Invalid Params",
          "message": "Query params are invalid, please try again",
          "code": 400
        }
      ]
    }
  end
end