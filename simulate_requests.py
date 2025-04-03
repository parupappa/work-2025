import requests
import random
import time
import uuid

BASE_URL = "http://rails_datadog_app-web:3000/articles"

def random_title():
    return f"Test-{uuid.uuid4().hex[:6]}"

def create_article():
    data = {
        "article": {
            "title": random_title(),
            "body": "This is a test body for Datadog APM."
        }
    }
    response = requests.post(BASE_URL, json=data)
    print(f"[CREATE] Status: {response.status_code}")

def list_articles():
    response = requests.get(BASE_URL)
    print(f"[LIST] Status: {response.status_code}")
    try:
        articles = response.json()
        return articles
    except:
        return []

def get_article(article_id):
    response = requests.get(f"{BASE_URL}/{article_id}")
    print(f"[GET] /{article_id} Status: {response.status_code}")

def update_article(article_id):
    data = {
        "article": {
            "title": random_title(),
            "body": "Updated body for APM test."
        }
    }
    response = requests.patch(f"{BASE_URL}/{article_id}", json=data)
    print(f"[UPDATE] /{article_id} Status: {response.status_code}")

def delete_article(article_id):
    response = requests.delete(f"{BASE_URL}/{article_id}")
    print(f"[DELETE] /{article_id} Status: {response.status_code}")

actions = ["create", "list", "get", "update", "delete"]

def main():
    for _ in range(20):  # 回数はお好みで
        action = random.choice(actions)
        if action == "create":
            create_article()
        else:
            articles = list_articles()
            if not articles:
                continue
            article = random.choice(articles)
            article_id = article.get("id")
            if action == "get":
                get_article(article_id)
            elif action == "update":
                update_article(article_id)
            elif action == "delete":
                delete_article(article_id)
        time.sleep(random.uniform(0.5, 2))  # 少し間をあけて自然なアクセスに

if __name__ == "__main__":
    main()
