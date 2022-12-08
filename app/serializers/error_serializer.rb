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
end