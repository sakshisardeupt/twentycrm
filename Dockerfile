# Demo: server + worker in one container (fits Render Free — 1 web service only)
FROM twentycrm/twenty:latest

COPY start-demo.sh /app/start-demo.sh

CMD ["sh", "/app/start-demo.sh"]
