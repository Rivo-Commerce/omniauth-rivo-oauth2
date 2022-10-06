module WebMock
  class RequestStub
    def with_any_query
      with(query: API.hash_including({}))
    end
  end
end
