#!/bin/bash

BASE_URL="http://localhost:3000/articles"
ACTIONS=("list" "create" "get" "update" "delete")

# ランダムな文字列生成
random_string() {
  cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1
}

# リクエスト送信
for i in {1..20}; do
  ACTION=${ACTIONS[$RANDOM % ${#ACTIONS[@]}]}
  echo "[RUNNING] Action: $ACTION"

  case $ACTION in
    list)
      curl -s -o /dev/null -w "[LIST] HTTP %{http_code}\n" "$BASE_URL"
      ;;

    create)
      TITLE="Test-$(random_string)"
      BODY="This is a test body."
      curl -s -o /dev/null -w "[CREATE] HTTP %{http_code}\n" \
        -H "Content-Type: application/json" \
        -X POST -d "{\"article\": {\"title\": \"$TITLE\", \"body\": \"$BODY\"}}" "$BASE_URL"
      ;;

    get | update | delete)
      # Get list of articles
      ARTICLES=$(curl -s "$BASE_URL")
      IDS=$(echo "$ARTICLES" | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
      ID=$(echo "$IDS" | shuf -n 1)

      if [ -z "$ID" ]; then
        echo "No articles found. Skipping $ACTION."
        continue
      fi

      if [ "$ACTION" = "get" ]; then
        curl -s -o /dev/null -w "[GET] /$ID HTTP %{http_code}\n" "$BASE_URL/$ID"
      elif [ "$ACTION" = "update" ]; then
        TITLE="Updated-$(random_string)"
        BODY="Updated body."
        curl -s -o /dev/null -w "[UPDATE] /$ID HTTP %{http_code}\n" \
          -H "Content-Type: application/json" \
          -X PATCH -d "{\"article\": {\"title\": \"$TITLE\", \"body\": \"$BODY\"}}" "$BASE_URL/$ID"
      elif [ "$ACTION" = "delete" ]; then
        curl -s -o /dev/null -w "[DELETE] /$ID HTTP %{http_code}\n" -X DELETE "$BASE_URL/$ID"
      fi
      ;;
  esac

  # ランダムに待機
  sleep $(shuf -i 1-3 -n 1)
done
