require 'rails_helper'

RSpec.describe Project, type: :model do

  # プロジェクト名がなければ登録できないこと
  it "is invalid without a name" do
    project = FactoryBot.build(:project, name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  # ユーザー単位では重複したプロジェクト名を許可しないこと
  it "does not allow duplicate project names per user" do
    project = FactoryBot.create(:project, name: "Test Project")
    new_project = FactoryBot.build(:project, name: project.name, owner: project.owner)

    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  # 二人のユーザーが同じ名前を使うことは許可すること
  it "allows two users to share a project name" do
    project = FactoryBot.create(:project, name: "Test Project")
    other_project = FactoryBot.build(:project, name: project.name)

    expect(other_project).to be_valid
  end

  # 遅延ステータス
  context "late status" do
    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    # 締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    # 締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
