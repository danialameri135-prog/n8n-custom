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

# 🔥 افزایش محدودیت حافظه Node.js
ENV NODE_OPTIONS="--max-old-space-size=4096"

# ... بقیه Dockerfile مثل قبل ...

# رفتن به پوشه custom و نصب نودهای مورد نظر
WORKDIR /custom
RUN npm init -y && \
    npm install n8n-nodes-bale-messenger-alpha

# 🔥 مهم: مسیر نودهای سفارشی رو به n8n معرفی کنید
ENV N8N_CUSTOM_EXTENSIONS="/custom/node_modules"

# برگشت به پوشه اصلی n8n
WORKDIR /usr/local/lib/node_modules/n8n

FROM alpine:latest AS alpine

FROM n8nio/n8n:latest

COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

USER root
RUN apk add --no-cache ffmpeg

# 🌟 پوشه نودهای سفارشی را بسازید
RUN mkdir -p /home/node/.n8n/custom && chown -R node:node /home/node/.n8n

USER node

# 🌟 نود را در پوشه موقت نصب کنید
WORKDIR /tmp
RUN npm init -y && npm install n8n-nodes-bale-messenger-alpha

# 🌟 فایل‌های build شده را به پوشه custom کپی کنید
RUN cp -r /tmp/node_modules/n8n-nodes-bale-messenger-alpha /home/node/.n8n/custom/

# 🌟 مسیر را به n8n معرفی کنید
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom/n8n-nodes-bale-messenger-alpha"

WORKDIR /usr/local/lib/node_modules/n8n
