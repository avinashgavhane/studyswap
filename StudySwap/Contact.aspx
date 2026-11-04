<%@ Page Title="Contact Us - StudySwap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="StudySwap.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  <link href="Content/contact.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="contact-hero">
        <div class="container text-center">
            <h1>Get In Touch</h1>
            <p>We're here to help! Reach out to us with any questions or concerns.</p>
        </div>
    </section>

    <!-- Main Contact Section -->
    <section class="contact-section">
        <div class="container">
            <div class="row g-4">
                <!-- Contact Form -->
                <div class="col-lg-7">
                    <div class="contact-form-card">
                        <h2 class="mb-4 fw-bold">Send Us a Message</h2>
                        
                        <!-- Success Message -->
                        <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-message" Visible="false">
                            <span style="font-size: 1.5rem;">✓</span>
                            <div>
                                <strong>Message Sent Successfully!</strong><br />
                                We'll get back to you within 24-48 hours.
                            </div>
                        </asp:Panel>

                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation-summary-errors mb-3" HeaderText="Please correct the following:" />

                        <div class="row g-3">
                            <!-- Name Field -->
                            <div class="col-md-6">
                                <label class="form-label">Your Name *</label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="John Doe"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" 
                                    ErrorMessage="Name is required" Display="Dynamic" CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                            </div>

                            <!-- Email Field -->
                            <div class="col-md-6">
                                <label class="form-label">Email Address *</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="john@college.edu"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                                    ErrorMessage="Email is required" Display="Dynamic" CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                                    ErrorMessage="Invalid email format" Display="Dynamic" CssClass="field-validation-error"
                                    ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w+$">
                                </asp:RegularExpressionValidator>
                            </div>

                            <!-- ✅ NEW: Mobile Field -->
                            <div class="col-md-6">
                                <label class="form-label">Mobile Number *</label>
                                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" 
                                    TextMode="Phone" placeholder="+91 98765-43210" MaxLength="15"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ControlToValidate="txtMobile" 
                                    ErrorMessage="Mobile number is required" Display="Dynamic" CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revMobile" runat="server" ControlToValidate="txtMobile"
                                    ErrorMessage="Enter a valid mobile number (10-15 digits)" Display="Dynamic" CssClass="field-validation-error"
                                    ValidationExpression="^\+?[0-9\s\-]{10,15}$">
                                </asp:RegularExpressionValidator>
                            </div>

                            <!-- Subject Field -->
                            <div class="col-md-6">
                                <label class="form-label">Subject *</label>
                                <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-select">
                                    <asp:ListItem Value="">-- Select Subject --</asp:ListItem>
                                    <asp:ListItem Value="General">General Inquiry</asp:ListItem>
                                    <asp:ListItem Value="Technical">Technical Support</asp:ListItem>
                                    <asp:ListItem Value="Complaint">Complaint</asp:ListItem>
                                    <asp:ListItem Value="Suggestion">Suggestion</asp:ListItem>
                                    <asp:ListItem Value="Partnership">Partnership Opportunity</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="ddlSubject" 
                                    ErrorMessage="Subject is required" Display="Dynamic" CssClass="field-validation-error"
                                    InitialValue="">
                                </asp:RequiredFieldValidator>
                            </div>

                            <!-- Message Field -->
                            <div class="col-12">
                                <label class="form-label">Your Message *</label>
                                <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" 
                                    placeholder="Tell us how we can help you..."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" 
                                    ErrorMessage="Message is required" Display="Dynamic" CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                            </div>

                            <!-- Submit Button -->
                            <div class="col-12 text-center mt-4">
                                <asp:Button ID="btnSubmit" runat="server" CssClass="btn-submit" Text="Send Message" OnClick="btnSubmit_Click" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact Info Cards -->
                <div class="col-lg-5">
                    <div class="row g-4">
                        <!-- Email Card -->
                        <div class="col-12">
                            <div class="contact-info-card">
                                <div class="contact-icon">✉️</div>
                                <h3 class="contact-info-title">Email Us</h3>
                                <p class="contact-info-text">
                                    <a href="mailto:support@studyswap.com" class="contact-info-link">support@studyswap.com</a><br />
                                    Response time: 24-48 hours
                                </p>
                            </div>
                        </div>

                        <!-- Mobile Card -->
                        <div class="col-12">
                            <div class="contact-info-card">
                                <div class="contact-icon">📱</div>
                                <h3 class="contact-info-title">Mobile</h3>
                                <p class="contact-info-text">
                                    <a href="tel:+919876543210" class="contact-info-link">+91 98765-43210</a><br />
                                    Available: 9:00 AM - 9:00 PM IST
                                </p>
                            </div>
                        </div>

                        <!-- Phone Card -->
                        <div class="col-12">
                            <div class="contact-info-card">
                                <div class="contact-icon">📞</div>
                                <h3 class="contact-info-title">Call Us</h3>
                                <p class="contact-info-text">
                                    <a href="tel:+911234567890" class="contact-info-link">+91 123-456-7890</a><br />
                                    Mon-Fri: 9:00 AM - 6:00 PM IST
                                </p>
                            </div>
                        </div>

                        <!-- Location Card -->
                        <div class="col-12">
                            <div class="contact-info-card">
                                <div class="contact-icon">📍</div>
                                <h3 class="contact-info-title">Visit Us</h3>
                                <p class="contact-info-text">
                                    StudySwap Headquarters<br />
                                    123 Campus Road, Academic Block<br />
                                    Warora, Maharashtra 442907
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FAQ Section -->
    <section class="faq-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Frequently Asked Questions</h2>
                <p class="section-subtitle">Quick answers to common questions</p>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="faq-item">
                        <div class="faq-question">How do I get verified as a student?</div>
                        <div class="faq-answer">Register with your college email or upload your student ID during signup. Our admin team typically verifies accounts within 24 hours.</div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">Is there a fee to use StudySwap?</div>
                        <div class="faq-answer">No! StudySwap is completely free for all verified students. We don't charge any listing fees or transaction commissions.</div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">How do I report inappropriate listings?</div>
                        <div class="faq-answer">Click the "Report Listing" button on any item details page. Our moderation team reviews all reports within 24 hours.</div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">Can I swap items instead of selling?</div>
                        <div class="faq-answer">Absolutely! When creating a listing, you can choose "For Swap" or "Both" to accept swap offers alongside purchase offers.</div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">What if I have a dispute with another student?</div>
                        <div class="faq-answer">Contact us immediately through this form or email support@studyswap.com. We'll mediate and help resolve any transaction issues.</div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">How is environmental impact calculated?</div>
                        <div class="faq-answer">We use industry-standard calculations based on item type, weight, and manufacturing emissions. Each reused textbook saves approximately 2.5 kg of CO₂.</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Social Section -->
    <section class="social-section">
        <div class="container">
            <h2 class="h1 fw-bold mb-3">Connect With Us</h2>
            <p class="lead">Follow us on social media for updates, tips, and campus stories</p>
            <div class="social-icons">
                <a href="#" class="social-icon" title="Facebook">📘</a>
                <a href="#" class="social-icon" title="Twitter">🐦</a>
                <a href="#" class="social-icon" title="Instagram">📷</a>
                <a href="#" class="social-icon" title="LinkedIn">💼</a>
                <a href="#" class="social-icon" title="YouTube">📺</a>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // FAQ accordion animation
        document.addEventListener('DOMContentLoaded', function () {
            const faqItems = document.querySelectorAll('.faq-item');

            faqItems.forEach(item => {
                const answer = item.querySelector('.faq-answer');
                const originalHeight = answer.scrollHeight;

                answer.style.maxHeight = '0';
                answer.style.overflow = 'hidden';
                answer.style.transition = 'max-height 0.3s ease, margin-top 0.3s ease';
                answer.style.marginTop = '0';

                item.addEventListener('click', function () {
                    const isOpen = answer.style.maxHeight !== '0px';

                    faqItems.forEach(otherItem => {
                        const otherAnswer = otherItem.querySelector('.faq-answer');
                        otherAnswer.style.maxHeight = '0';
                        otherAnswer.style.marginTop = '0';
                    });

                    if (!isOpen) {
                        answer.style.maxHeight = originalHeight + 'px';
                        answer.style.marginTop = '10px';
                    }
                });
            });
        });

        <% if (pnlSuccess.Visible) { %>
            document.addEventListener('DOMContentLoaded', function() {
                const successMsg = document.querySelector('.success-message');
                if (successMsg) {
                    successMsg.classList.add('show');
                    setTimeout(() => {
                        successMsg.style.opacity = '0';
                        setTimeout(() => successMsg.style.display = 'none', 300);
                    }, 5000);
                }
            });
        <% } %>
    </script>
</asp:Content>