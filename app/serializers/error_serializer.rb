class ErrorSerializer
  def initialize(search)
    @search = search
  end

  def no_found_merchant
    {
      'errors': [
        {
          "status": "NOT FOUND",
          "message": "No merchants found by the name #{@search}",
          "code": 404
        }
      ]
    }
  end
end