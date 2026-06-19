# استفاده از ایمیج رسمی n8n به عنوان پایه
FROM n8nio/n8n:latest

# نصب ابزارهای مورد نیاز و ایجاد پوشه برای نودهای سفارشی
USER root
RUN apk add --no-cache ffmpeg && \
    mkdir -p /custom && chown node:node /custom

# برگشت به کاربر node برای نصب نودها
USER node

# رفتن به پوشه custom و نصب نودهای مورد نظر
WORKDIR /custom
RUN npm init -y && \
    npm install n8n-nodes-bale-messenger-alpha

# برگشت به پوشه اصلی n8n
WORKDIR /usr/local/lib/node_modules/n8n
