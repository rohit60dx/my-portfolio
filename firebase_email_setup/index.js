const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");
const { Resend } = require("resend");

// Apna naya Resend API key yahan daalein (Purana wala delete zaroor kar dena)
const resend = new Resend('re_8iGS56NX_2jasgYqeZzXcHsFknpUJZn9d');

// 'contacts' collection mein naya document aate hi ye function chalega
exports.sendEmailOnNewContact = onDocumentCreated("contacts/{docId}", async (event) => {
    // Naye document ka data nikalein
    const snapshot = event.data;
    if (!snapshot) {
        logger.error("No data associated with the event");
        return;
    }
    const data = snapshot.data();

    try {
        const { data: resendData, error } = await resend.emails.send({
            from: 'Portfolio <onboarding@resend.dev>', // Resend verified domain
            to: ['rohit50dx@gmail.com'],
            subject: `New Contact from ${data.name}`,
            html: `
        <h2>New Message Received</h2>
        <p><strong>Name:</strong> ${data.name}</p>
        <p><strong>Email:</strong> ${data.email}</p>
        <p><strong>Message:</strong></p>
        <p style="white-space: pre-wrap;">${data.message}</p>
      `
        });

        if (error) {
            logger.error("Resend API Error:", error);
            return null;
        }

        logger.info('✅ Email sent successfully:', resendData);
        return resendData;

    } catch (err) {
        logger.error('❌ Function Error:', err);
        return null;
    }
});