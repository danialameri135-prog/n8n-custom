# مرحله ۱: گرفتن apk از Alpine
FROM alpine:latest AS alpine

# مرحله ۲: استفاده از تصویر اصلی n8n
FROM n8nio/n8n:latest

# کپی کردن apk از Alpine به n8n
COPY --from=alpine /sbin/apk /sbin/apk
COPY --from=alpine /usr/lib/libapk.so* /usr/lib/

USER root
RUN apk add --no-cache ffmpeg

# ایجاد پوشه نودهای سفارشی با دسترسی مناسب
RUN mkdir -p /home/node/.n8n/custom && chown -R node:node /home/node/.n8n

USER node

# نصب نود Bale Messenger در یک پوشه موقت
WORKDIR /tmp
RUN npm init -y && npm install n8n-nodes-bale-messenger-alpha

# کپی فایل‌های نصب‌شده به پوشه‌ای که n8n آن را می‌خواند
RUN cp -r /tmp/node_modules/n8n-nodes-bale-messenger-alpha /home/node/.n8n/custom/

# معرفی مسیر نودهای سفارشی به n8n
ENV N8N_CUSTOM_EXTENSIONS="/home/node/.n8n/custom/n8n-nodes-bale-messenger-alpha"

# افزایش محدودیت حافظه (اختیاری اما مفید)
ENV NODE_OPTIONS="--max-old-space-size=4096"

# برگشت به پوشه اصلی n8n
WORKDIR /usr/local/lib/node_modules/n8n

# دستور اجرای n8n (برای اینکه Render بداند چگونه شروع کند)
CMD ["node", "bin/n8n"]# 🔥 مهم: مسیر نودهای سفارشی رو به n8n معرفی کنید
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
