
# **Zphisher, CamPhisher, WiFiPhisher, and Cloudflare Tunnel Integration**

This tool is an integration of three popular ethical hacking and phishing tools: **Zphisher**, **CamPhisher**, and **WiFiPhisher**, with added support for **Cloudflare Tunnel**. This tool was modified to combine these tools into one for easier usage, with the added feature of running each tool on a custom port.

**Note**: This tool was not created from scratch by me. I modified these integrated tools to add new features and improve the user experience.

## **Requirements**

The following tools are required for the tool to function correctly:

- `git`
- `php`
- `cloudflared`
- `ngrok`
- **WiFiPhisher** (must be installed manually)

If these tools are missing, they will be automatically downloaded when running the tool (except for WiFiPhisher, which needs to be installed manually).

## **Installation Instructions**

1. Clone the repository:
    ```bash
    git clone https://github.com/sb3ly/UST-phishing.git
    cd UST-phishing
    ```

2. Ensure you are using an environment that supports these tools Like Linux.

3. The missing tools will be automatically downloaded (such as `cloudflared` and `ngrok`) if they are not installed.

4. **WiFiPhisher** must be installed manually. Follow the installation instructions from the official [WiFiPhisher GitHub page](https://github.com/WiFiPhisher/WiFiPhisher).

## **How to Use**

After installation, you can run the tool by executing the following command:
```chmod +x phishing-tools.sh
./phishing-tools.sh
```

The main menu will appear where you can choose which tool to run:

- **[1]** Run **Zphisher**
- **[2]** Run **CamPhish**
- **[3]** Run **WiFiPhisher**
- **[4]** Run **Cloudflare Tunnel only**
- **[5]** Exit

### **Tool Options**
- When selecting a tool, you will be prompted to enter the port you wish to use.
- If you select "Cloudflare Tunnel", it will guide you to the `cloudflared` interface to start the tunnel.

## **Additional Features**
- Integration of **Zphisher**, **CamPhisher**, **WiFiPhisher**, and **Cloudflare Tunnel**.
- Automatic dependency checks and installation of missing tools like `cloudflared` and `ngrok`.
- Ability to run the tools on a custom port.

## **License**

This tool was modified from the original tools available on GitHub, with added improvements to enhance the user experience.

## **Disclaimers**

This tool is intended for educational purposes only, and should not be used for any illegal or harmful activity. Always ensure you have permission from the parties involved before using these tools in any environment.

---

**Modified by SB3LY**

---

## ARABIC

# **Zphisher, CamPhisher, WiFiPhisher, and Cloudflare Tunnel Integration**

هذه الأداة هي دمج بين ثلاث أدوات مشهورة في مجال الاختراق الأخلاقي والتصيد الاحتيالي: **Zphisher** و **CamPhisher** و **WiFiPhisher**، مع إضافة دعم لـ **Cloudflare Tunnel**. تم تعديل هذه الأداة لتجميع هذه الأدوات في أداة واحدة لسهولة الاستخدام، مع إضافة خيارات لتشغيل كل أداة على بورت مخصص.

**ملاحظة**: هذه الأداة ليست من إنشائي من الصفر. تم تعديل هذه الأدوات المدمجة من أجل إضافة ميزات جديدة وتحسين تجربة الاستخدام.

## **المتطلبات**

تحتاج إلى الأدوات التالية لتشغيل الأداة بشكل صحيح:

- `git`
- `php`
- `cloudflared`
- `ngrok`
- **WiFiPhisher** (يجب تثبيتها يدويًا)

إذا لم تكن هذه الأدوات مثبتة، فسيتم تنزيل الأدوات المفقودة تلقائيًا عند تشغيل الأداة (باستثناء WiFiPhisher، التي يجب تثبيتها يدويًا).

## **طريقة التثبيت**

1. قم بتحميل الأداة عبر Git:
    ```bash
    git clone https://github.com/sb3ly/UST-phishing.git
    cd UST-phishing
    ```

2. تأكد من أنك تستخدم بيئة تعمل على نظام تشغيل يدعم الأدوات (مثل لينكس ).

3. قم بتثبيت الأدوات اللازمة إذا كانت مفقودة. عند تشغيل الأداة، سيتم تحميل الأدوات المفقودة مثل `cloudflared` و `ngrok` بشكل تلقائي.

4. يجب تثبيت **WiFiPhisher** يدويًا. اتبع تعليمات التثبيت من صفحة [WiFiPhisher GitHub الرسمية](https://github.com/WiFiPhisher/WiFiPhisher).

## **طريقة الاستخدام**

بعد التثبيت، يمكنك تشغيل الأداة عبر تنفيذ الأمر التالي:
```bash
chmod +x phishing-tools.sh
./phishing-tools.sh
```

سيتم عرض القائمة الرئيسية حيث يمكنك اختيار الأداة التي تريد تشغيلها:

- **[1]** تشغيل **Zphisher**
- **[2]** تشغيل **CamPhish**
- **[3]** تشغيل **WiFiPhisher**
- **[4]** تشغيل **Cloudflare Tunnel** فقط
- **[5]** الخروج

### **اختيارات الأداة**
- عند اختيار الأداة، سيطلب منك إدخال البورت الذي تريد تشغيل الأداة عليه.
- في حالة اختيار "Cloudflare Tunnel"، سيتم توجيهك إلى واجهة `cloudflared` لتشغيل النفق.

## **الخصائص المضافة**
- دمج بين **Zphisher** و **CamPhisher** و **WiFiPhisher** مع دعم لـ **Cloudflare Tunnel**.
- التحقق من المتطلبات تلقائيًا وتثبيت الأدوات المفقودة مثل `cloudflared` و `ngrok`.
- إمكانية تشغيل الأدوات على بورت مخصص.

## **الترخيص**

تم تعديل هذه الأداة من الأدوات الأصلية الموجودة على GitHub وتم إضافة بعض التعديلات لتحسين التفاعل وسهولة الاستخدام.

## **تنبيهات**

تُستخدم هذه الأداة لأغراض تعليمية فقط، ولا يجب استخدامها في أي نشاط غير قانوني أو ضار. تأكد دائمًا من الحصول على إذن من الأطراف المعنية قبل استخدام الأدوات في أي بيئة.

---

**تم التعديل بواسطة SB3LY**
