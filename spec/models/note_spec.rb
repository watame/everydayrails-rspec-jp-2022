require 'rails_helper'

RSpec.describe Note, type: :model do

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(FactoryBot.build(:note)).to be_valid
  end

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    project = FactoryBot.build(:project)
    note = FactoryBot.build(
      :note,
      project: project,
      user: project.owner
    )
    expect(note).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without a message" do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 文字列に一致するメッセージを検索する
  describe "search message for a term" do
    before do
      project = FactoryBot.create(:project)

      @note1 = FactoryBot.create(
        :note,
        message: "This is the first note.",
        project: project,
        user: project.owner
      )

      @note2 = FactoryBot.create(
        :note,
        message: "This is the second note.",
        project: project,
        user: project.owner
      )

      @note3 = FactoryBot.create(
        :note,
        message: "First, preheat the ove.",
        project: project,
        user: project.owner
      )
    end

    # 一致するデータが見つかるとき
    context "when a match is found" do
      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
        expect(Note.search("first")).to include(@note1, @note3)
        expect(Note.search("first")).to_not include(@note2)
      end
    end

    # 一致するデータが1件も見つからないとき
    context "when no match is found" do
      # 検索結果が1件も見つからなければ空のコレクションを返すこと
      it "returns an empty collection" do
        expect(Note.search("message")).to be_empty
      end
    end
  end
end
