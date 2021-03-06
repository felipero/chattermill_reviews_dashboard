defmodule ChattermillReviewServiceWeb.AverageControllerTest do
  use ChattermillReviewServiceWeb.ConnCase, async: false
  import ChattermillReviewService.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "categories" do
    test "lists all category averages", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme one", category: category_one)
      theme_two = insert(:theme, name: "Theme two", category: category_one)
      theme_three = insert(:theme, name: "Theme three", category: category_two)
      theme_four = insert(:theme, name: "Theme four", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :categories))

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 0.33},
                 %{"name" => "Category 2", "id" => category_two.id, "sentiment" => -0.25}
               ]
             } == json_response(conn, 200)

      conn = get(conn, Routes.average_path(conn, :categories), id: nil)

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 0.33},
                 %{"name" => "Category 2", "id" => category_two.id, "sentiment" => -0.25}
               ]
             } == json_response(conn, 200)

      conn = get(conn, Routes.average_path(conn, :categories), id: "")

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 0.33},
                 %{"name" => "Category 2", "id" => category_two.id, "sentiment" => -0.25}
               ]
             } == json_response(conn, 200)
    end

    test "list a category average of an specific id", %{conn: conn} do
      category_one = insert(:category, id: 56_432, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme one", category: category_one)
      theme_two = insert(:theme, name: "Theme two", category: category_one)
      theme_three = insert(:theme, name: "Theme three", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)

      conn = get(conn, Routes.average_path(conn, :categories), id: "56432")

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 0.33}
               ]
             } == json_response(conn, 200)
    end

    test "list cateogries that contain a phrase review comment", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")
      category_three = insert(:category, name: "Category 3")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, name: "Theme 2", category: category_two)
      theme_three = insert(:theme, name: "Theme 3", category: category_three)

      review_one = insert(:review, comment: "you are all amazing people!")
      review_two = insert(:review, comment: "people are ok!")

      insert(:theme_sentiment, review: review_one, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, review: review_one, theme: theme_two, sentiment: 0)
      insert(:theme_sentiment, review: review_two, theme: theme_two, sentiment: -1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :categories), term: "are")

      assert %{
               "averages" => [
                 %{"name" => "Category 1", "id" => category_one.id, "sentiment" => 1.0},
                 %{"name" => "Category 2", "id" => category_two.id, "sentiment" => -0.5}
               ]
             } == json_response(conn, 200)
    end
  end

  describe "themes" do
    test "lists all theme averages", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, name: "Theme 2", category: category_one)
      theme_three = insert(:theme, name: "Theme 3", category: category_two)
      theme_four = insert(:theme, name: "Theme 4", category: category_two)

      # Category 1 sentiments
      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      # Category two sentiment
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: -1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: -1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)
      insert(:theme_sentiment, theme: theme_four, sentiment: 1)
      insert(:theme_sentiment, theme: theme_four, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :themes))

      assert %{
               "averages" => [
                 %{"name" => "Theme 1", "id" => theme_one.id, "sentiment" => 0.00},
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => 0.67},
                 %{"name" => "Theme 3", "id" => theme_three.id, "sentiment" => -0.67},
                 %{"name" => "Theme 4", "id" => theme_four.id, "sentiment" => 0.00}
               ]
             } == json_response(conn, 200)

      conn = get(conn, Routes.average_path(conn, :themes), id: nil)

      assert %{
               "averages" => [
                 %{"name" => "Theme 1", "id" => theme_one.id, "sentiment" => 0.00},
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => 0.67},
                 %{"name" => "Theme 3", "id" => theme_three.id, "sentiment" => -0.67},
                 %{"name" => "Theme 4", "id" => theme_four.id, "sentiment" => 0.00}
               ]
             } == json_response(conn, 200)

      conn = get(conn, Routes.average_path(conn, :themes), id: "")

      assert %{
               "averages" => [
                 %{"name" => "Theme 1", "id" => theme_one.id, "sentiment" => 0.00},
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => 0.67},
                 %{"name" => "Theme 3", "id" => theme_three.id, "sentiment" => -0.67},
                 %{"name" => "Theme 4", "id" => theme_four.id, "sentiment" => 0.00}
               ]
             } == json_response(conn, 200)
    end

    test "lists a theme average of an specific id", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, id: 34_543, name: "Theme 2", category: category_one)

      insert(:theme_sentiment, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, theme: theme_one, sentiment: 0)
      insert(:theme_sentiment, theme: theme_one, sentiment: -1)

      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :themes), id: "34543")

      assert %{
               "averages" => [
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => 0.67}
               ]
             } == json_response(conn, 200)
    end

    test "list themes that contain a phrase review comment", %{conn: conn} do
      category_one = insert(:category, name: "Category 1")
      category_two = insert(:category, name: "Category 2")
      category_three = insert(:category, name: "Category 3")

      theme_one = insert(:theme, name: "Theme 1", category: category_one)
      theme_two = insert(:theme, name: "Theme 2", category: category_two)
      theme_three = insert(:theme, name: "Theme 3", category: category_three)

      review_one = insert(:review, comment: "you are all amazing people!")
      review_two = insert(:review, comment: "people are ok!")

      insert(:theme_sentiment, review: review_one, theme: theme_one, sentiment: 1)
      insert(:theme_sentiment, review: review_one, theme: theme_two, sentiment: 0)
      insert(:theme_sentiment, review: review_two, theme: theme_two, sentiment: -1)
      insert(:theme_sentiment, theme: theme_two, sentiment: 1)
      insert(:theme_sentiment, theme: theme_three, sentiment: 0)

      conn = get(conn, Routes.average_path(conn, :themes), term: "are")

      assert %{
               "averages" => [
                 %{"name" => "Theme 1", "id" => theme_one.id, "sentiment" => 1.0},
                 %{"name" => "Theme 2", "id" => theme_two.id, "sentiment" => -0.5}
               ]
             } == json_response(conn, 200)
    end
  end
end
