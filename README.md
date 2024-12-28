مراحل بلاک کردن وب سایت های speedtest , pornhub..... 
1. نصب Gitاگر بستهٔ git روی سرور نصب نیست، نصبش کنید:

sudo apt update
sudo apt install git -y

2. کلون کردن مخزن گیت‌هاب
داخل سرور، با دستور زیر مخزن را کلون کنید:

git clone https://github.com/MmmdreZadev/block-speedtest.git

3. وارد پوشه شده و مجوز اجرا بدهید

cd block-speedtest
chmod +x block_speedtest.sh

4. اجرای اسکریپت

sudo ./block_speedtest.sh

5. (اختیاری) ذخیره تنظیمات پس از ری‌استارت

sudo apt install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
