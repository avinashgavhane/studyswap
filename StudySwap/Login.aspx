<%@ Page Title="Login - StudySwap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="StudySwap.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="Content/Login.css" rel="stylesheet">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="login-container">
        <div class="login-wrapper">
            <!-- Left Panel - Welcome Section -->
            <div class="welcome-panel">
                <div class="welcome-icon">🎓</div>
                <h1>Welcome Back!</h1>
                <p>Sign in to continue your sustainable academic journey. Buy, sell, and swap educational resources while making a positive impact on the environment.</p>
                
                <ul class="feature-list">
                    <li class="feature-item">Access verified campus marketplace</li>
                    <li class="feature-item">Save up to 70% on textbooks</li>
                    <li class="feature-item">Track your environmental impact</li>
                    <li class="feature-item">Connect with fellow students</li>
                    <li class="feature-item">Secure and trusted transactions</li>
                </ul>
            </div>

            <!-- Right Panel - Login Form -->
            <div class="login-panel">
                <div class="login-header">
                    <h2>Sign In(Admin & Student)</h2>
                    <p>Enter your credentials to access your account</p>
                </div>

                <!-- Error Message -->
                <asp:Panel ID="pnlError" runat="server" CssClass="alert-message alert-error" Visible="false">
                    <span>⚠️</span>
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </asp:Panel>

                <!-- Success Message -->
                <asp:Panel ID="pnlSuccess" runat="server" CssClass="alert-message alert-success" Visible="false">
                    <span>✓</span>
                    <asp:Label ID="lblSuccess" runat="server"></asp:Label>
                </asp:Panel>

                <!-- Warning Message (Unverified Account) -->
                <asp:Panel ID="pnlWarning" runat="server" CssClass="alert-message alert-warning" Visible="false">
                    <span>⏳</span>
                    <asp:Label ID="lblWarning" runat="server"></asp:Label>
                </asp:Panel>

                <!-- Validation Summary -->
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                    CssClass="validation-summary-errors" 
                    HeaderText="Please correct the following:" />

                <!-- Email Field -->
                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📧</span>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" 
                            TextMode="Email" placeholder="student@college.edu"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                        ControlToValidate="txtEmail" 
                        ErrorMessage="Email is required" 
                        Display="Dynamic" 
                        CssClass="field-validation-error">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                        ControlToValidate="txtEmail"
                        ErrorMessage="Invalid email format" 
                        Display="Dynamic" 
                        CssClass="field-validation-error"
                        ValidationExpression="^[\w\.-]+@[\w\.-]+\.\w+$">
                    </asp:RegularExpressionValidator>
                </div>

                <!-- Password Field -->
                <div class="form-group">
                    <label class="form-label">Password</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                            TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                        ControlToValidate="txtPassword" 
                        ErrorMessage="Password is required" 
                        Display="Dynamic" 
                        CssClass="field-validation-error">
                    </asp:RequiredFieldValidator>
                </div>

                <!-- Remember Me & Forgot Password -->
                <div class="form-options">
                    <div class="remember-me">
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        <label for="<%= chkRememberMe.ClientID %>">Remember me</label>
                    </div>
                    <a href="ForgotPassword.aspx" class="forgot-password" >Forgot Password?</a>
                </div>

                <!-- Login Button -->
                <asp:Button ID="btnLogin" runat="server" CssClass="btn-login" 
                    Text="Sign In" OnClick="btnLogin_Click" />

                <!-- Divider -->
                <div class="divider">
                    <span>New to StudySwap?</span>
                </div>

                <!-- Register Link -->
                <div class="register-link">
                    <p>Don't have an account? <a href="Register.aspx">Create Account</a></p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // Show loading state on login button
        function showLoading(btn) {
            if (Page_ClientValidate()) {
                btn.classList.add('loading');
                btn.disabled = true;
                return true;
            }
            return false;
        }

        // Auto-hide success/error messages after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-message');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    alert.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => alert.style.display = 'none', 500);
                }, 5000);
            });
        });

        // Prevent form resubmission
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }

        // Enter key submit
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.form-control');
            inputs.forEach(input => {
                input.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        document.getElementById('<%= btnLogin.ClientID %>').click();
                    }
                });
            });
        });
    </script>
</asp:Content>