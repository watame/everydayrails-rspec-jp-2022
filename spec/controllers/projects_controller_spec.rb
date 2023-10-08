require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  describe "#index" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :index
        expect(response).to be_successful
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        sign_in @user
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    # ゲストとして
    context "as a guest" do
      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get :index
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "#show" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # 正常にレスポンスを返すこと
      it "responds successfully" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_successful
      end

      # 200レスポンスを返すこと
      it "returns a 200 response" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to have_http_status(:ok)
      end
    end

    # 認可されていないユーザーとして
    context "as an unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to have_http_status(:found)
      end
    end

    # ゲストとして
    context "as a guest" do
      before do
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        get :show, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        get :show, params: { id: @project.id }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "#create" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
      end

      # プロジェクトを追加できること
      it "adds a project" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect {
          post :create, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        post :create, params: { project: project_params }
        expect(response).to have_http_status(:found)
      end

    end

    # ゲストとして
    context "as a guest" do
      before do
        @user = FactoryBot.create(:user)
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "#update" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを更新できること
      it "updates a project" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        # reloadでDBの値を取得する
        expect(@project.reload.name).to eq "New Project Name"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project, name: "New Project Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status(:found)
      end

    end

    # 認可されていないユーザーとして
    context "as a unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project,
          owner: other_user,
          name: "Same Old Name")
      end

      # プロジェクトを更新できないこと
      it "does not update the project" do
        project_params = FactoryBot.attributes_for(:project, name: "New Name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "Same Old Name"
      end

      # ダッシュボードへリダイレクトすること
      it "redirects to the dashboard" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status(:found)
      end
    end

    # ゲストとして
    context "as a guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        project_params = FactoryBot.attributes_for(:project)
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to have_http_status(:found)
      end
    end
  end

  context "#destroy" do
    # 認証済みユーザーとして
    context "as an authenticated user" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      # プロジェクトを更新できること
      it "deletes a project" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status(:see_other)
      end

    end

    # 認可されていないユーザーとして
    context "as a unauthorized user" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        sign_in @user
        expect{
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      # ダッシュボードへリダイレクトすること
      it "redirects to the dashboard" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status(:found)
      end
    end

    # ゲストとして
    context "as a guest" do
      before do
        @project = FactoryBot.create(:project)
      end

      # プロジェクトを削除できないこと
      it "does not delete the project" do
        expect{
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      # サインイン画面にリダイレクトすること
      it "redirects to the sign-in page" do
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to "/users/sign_in"
      end

      # 302レスポンスを返すこと
      it "returns a 302 response" do
        delete :destroy, params: { id: @project.id }
        expect(response).to have_http_status(:found)
      end
    end
  end

end
