require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index" do
    # 正常にレスポンスを返すこと
    it "responds successfully" do
      get :index
      # response => ブラウザに返すべきアプリケーションの全データを保持しているオブジェクト
      expect(response).to be_successful
    end

    # 200レスポンスを返すこと
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end
end
