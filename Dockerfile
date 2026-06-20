# مرحله ۱: گرفتن apk از یک تصویر Alpine
FROM alpine:latest AS alpine

# مرحله ۲: استفاده از تصویر اصلی n8n
FROM n8nio/n8n:latest

# کپی کردن apk از Alpine به n8n
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

# نصب ابزارها و ایجاد پوشه برای نودهای سفارشی
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
