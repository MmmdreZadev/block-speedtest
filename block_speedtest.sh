#!/usr/bin/env bash
#
# اسکریپت مسدودسازی دامنه‌های Speedtest با ipset + iptables
# نویسنده: [YourName]
#
# این اسکریپت A رکوردهای دامنه‌هایی که در آرایه DOMAINS تعریف شده‌اند
# را پیدا کرده و در ipset به نام 'speedtest_block' قرار می‌دهد.
# سپس با iptables همه ترافیک به/از این ipها بلاک می‌شود.
#

# لیست دامنه‌هایی که قصد بلاک دارید
DOMAINS=(
  "speedtest.net"
  "www.speedtest.net"
  "api.speedtest.net"
  "c.speedtest.net"
  # در صورت نیاز دامنه‌های دیگر Speedtest یا سایت‌های موردنظر را اضافه کنید
    "instagram.com"
  "www.instagram.com"

  # یوتیوب
  "youtube.com"
  "www.youtube.com"
  "m.youtube.com"        # یوتیوب موبایل
  "youtube-nocookie.com" # برای ویدیوهای جاسازی‌شده (embedded)
  "googlevideo.com"      # بسیاری از استریم‌های یوتیوب از این دامنه استفاده می‌کنند

  # سایت‌های پورنوگرافی (صرفاً مثال)
  "pornhub.com"
  "www.pornhub.com"
  "xvideos.com"
  "www.xvideos.com"
  "www.Xnxx.com"
  "Xnxx.com"
)

# یک مجموعه ipset به نام speedtest_block می‌سازیم (اگر موجود نباشد)
sudo ipset create speedtest_block hash:ip -exist

# برای هر دامنه، A رکوردهای IPv4 را می‌گیریم
for domain in "${DOMAINS[@]}"; do
  echo "→ در حال گرفتن IP های مربوط به: $domain"
  IP_LIST=$(dig +short A "$domain" | grep '^[0-9]\{1,3\}\.')
  
  if [ -z "$IP_LIST" ]; then
    echo "  ⚠ هیچ IP معتبری برای $domain پیدا نشد یا dig نصب نیست."
    continue
  fi
  
  # افزودن IPها به مجموعه speedtest_block
  for ip in $IP_LIST; do
    echo "  افزودن IP: $ip به speedtest_block..."
    sudo ipset add speedtest_block "$ip" -exist
  done
done

echo
echo "→ تنظیم رول iptables برای بلاک کردن ترافیک مربوط به speedtest_block ..."
# بلاک ترافیک خروجی به آی‌پی‌های داخل speedtest_block
sudo iptables -I OUTPUT -m set --match-set speedtest_block dst -j DROP
# (در صورت نیاز) بلاک ترافیک ورودی
sudo iptables -I INPUT -m set --match-set speedtest_block src -j DROP

echo
echo "✅ کار تمام شد!"
echo "برای مشاهدهٔ محتوای ipset:"
echo "  sudo ipset list speedtest_block"
echo "برای مشاهدهٔ رول‌های iptables:"
echo "  sudo iptables -L -n -v"
echo
echo "در صورت ری‌استارت، برای حفظ تنظیمات iptables و ipset از netfilter-persistent یا اسکریپت استارت‌آپ استفاده کنید."
