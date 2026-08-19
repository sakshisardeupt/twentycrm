# Demo: server + worker in one container (fits Render Free — 1 web service only)
FROM twentycrm/twenty:latest

USER root
COPY start-demo.sh /app/start-demo.sh
RUN chmod +x /app/start-demo.sh
USER 1000

CMD ["/app/start-demo.sh"]
