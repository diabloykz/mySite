require 'test_helper'

class CreateArticlesTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: "john", email: "john@example.com", password: "password", admin: false)
    @category = Category.create(name: "Sports")
    @category2 = Category.create(name: "Style de vie")
  end

  test "get new article form and create article" do
    sign_in_as(@user, "password")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: {article: {title: "titre de l'article'", description: "test du contenu de l'article'", category_ids: ["","1","2"]}}
    end
    follow_redirect!
    assert_template 'articles/show'
    assert_match "test du contenu", response.body
    assert_select "a[href=?]", category_path(@category), text: @category.name
    assert_select "a[href=?]", category_path(@category2), text: @category2.name
  end

end
