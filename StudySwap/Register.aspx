<%@ Page Title="Student Registration - StudySwap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="StudySwap.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/Register.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager2" runat="server" />

    <div class="register-container">
        <div class="container">
            <div class="register-card">
                <!-- Header -->
                <div class="register-header">
                    <div class="register-logo">🎓</div>
                    <h1>Join StudySwap</h1>
                    <p>Start saving money and helping the environment today!</p>
                </div>

                <!-- Progress Steps -->
                <div class="register-body">
                    <div class="progress-steps">
                        <div class="step active">
                            <div class="step-number">1</div>
                            <div class="step-label">Personal Info</div>
                        </div>
                        <div class="step active">
                            <div class="step-number">2</div>
                            <div class="step-label">College Details</div>
                        </div>
                        <div class="step active">
                            <div class="step-number">3</div>
                            <div class="step-label">Verification</div>
                        </div>
                    </div>

                    <!-- Success Message -->
                    <asp:Panel ID="pnlSuccess" runat="server" CssClass="success-message" Visible="false">
                        <span class="success-icon">✓</span>
                        <div>
                            <strong>Registration Successful!</strong><br />
                            Your account is pending. Login after Verify.
                        </div>
                    </asp:Panel>

                    <!-- Validation Summary -->
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                        CssClass="validation-summary-errors"
                        HeaderText="Please correct the following errors:" />

                    <!-- Personal Information Section -->
                    <div class="section-header">
                        <div class="section-icon">👤</div>
                        <h2 class="section-title">Personal Information</h2>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label class="form-label">Full Name <span class="required">*</span></label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                                    placeholder="Enter your full name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                                    ControlToValidate="txtFullName"
                                    ErrorMessage="Full Name is required"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Email Address <span class="required">*</span></label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                    TextMode="Email" placeholder="student@college.edu"></asp:TextBox>
                                <span class="help-text">Use your college email address</span>
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
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Phone Number <span class="required">*</span></label>
                                <asp:TextBox ID="txtPhone" MaxLength="10" runat="server" CssClass="form-control"
                                    placeholder="10-digit mobile number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ErrorMessage="Phone number is required"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revPhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ErrorMessage="Phone must be 10 digits"
                                    Display="Dynamic"
                                    CssClass="field-validation-error"
                                    ValidationExpression="^\d{10}$">
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Password <span class="required">*</span></label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                                    TextMode="Password" placeholder="Minimum 6 characters"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                    ControlToValidate="txtPassword"
                                    ErrorMessage="Password is required"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                    ControlToValidate="txtPassword"
                                    ErrorMessage="Password must be at least 6 characters"
                                    Display="Dynamic"
                                    CssClass="field-validation-error"
                                    ValidationExpression=".{6,}">
                                </asp:RegularExpressionValidator>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Confirm Password <span class="required">*</span></label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control"
                                    TextMode="Password" placeholder="Re-enter password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ErrorMessage="Please confirm password"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="cvPassword" runat="server"
                                    ControlToValidate="txtConfirmPassword"
                                    ControlToCompare="txtPassword"
                                    ErrorMessage="Passwords do not match"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:CompareValidator>
                            </div>
                        </div>
                    </div>

                    <!-- College Information Section -->
                    <div class="section-header mt-4">
                        <div class="section-icon">🏫</div>
                        <h2 class="section-title">College Information</h2>
                    </div>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">College Name <span class="required">*</span></label>
                                        <asp:DropDownList ID="ddlCollege" runat="server" CssClass="form-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlCollege_SelectedIndexChanged">
                                            <asp:ListItem Value="">-- Select College --</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvCollege" runat="server"
                                            ControlToValidate="ddlCollege"
                                            ErrorMessage="College is required"
                                            Display="Dynamic"
                                            CssClass="field-validation-error"
                                            InitialValue="">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">Department <span class="required">*</span></label>
                                        <asp:DropDownList ID="ddlDepartment" AutoPostBack="true" 
                                            OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged" 
                                            runat="server" CssClass="form-select">
                                            <asp:ListItem Value="">-- Select Department --</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvDepartment" runat="server"
                                            ControlToValidate="ddlDepartment"
                                            ErrorMessage="Department is required"
                                            Display="Dynamic"
                                            CssClass="field-validation-error"
                                            InitialValue="">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">Course <span class="required">*</span></label>
                                        <asp:DropDownList ID="ddlCourse" runat="server" AutoPostBack="true" CssClass="form-select">
                                            <asp:ListItem Value="">-- Select Course --</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvCourse" runat="server"
                                            ControlToValidate="ddlCourse"
                                            InitialValue=""
                                            ErrorMessage="Course is required"
                                            Display="Dynamic"
                                            CssClass="field-validation-error" />
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label">Year of Study <span class="required">*</span></label>
                                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select">
                                            <asp:ListItem Value="">-- Select Year --</asp:ListItem>
                                            <asp:ListItem Value="1">1st Year</asp:ListItem>
                                            <asp:ListItem Value="2">2nd Year</asp:ListItem>
                                            <asp:ListItem Value="3">3rd Year</asp:ListItem>
                                            <asp:ListItem Value="4">4th Year</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rfvYear" runat="server"
                                            ControlToValidate="ddlYear"
                                            InitialValue=""
                                            ErrorMessage="Year of Study is required"
                                            Display="Dynamic"
                                            CssClass="field-validation-error" />
                                    </div>
                                </div>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <!-- Verification Section -->
                    <div class="section-header mt-4">
                        <div class="section-icon">📋</div>
                        <h2 class="section-title">Verification Details</h2>
                    </div>

                    <div class="row g-3">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Roll Number <span class="required">*</span></label>
                                <asp:TextBox ID="txtRollNumber" runat="server" CssClass="form-control" 
                                    placeholder="Enter your roll number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRollNumber" runat="server"
                                    ControlToValidate="txtRollNumber"
                                    ErrorMessage="Roll Number is required"
                                    Display="Dynamic"
                                    CssClass="field-validation-error">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Upload Student Photo <span class="required">*</span></label>
                                <div class="file-upload-wrapper">
                                    <asp:FileUpload ID="fuStudentID" runat="server" CssClass="form-control-file" 
                                        onchange="displayFileName(this)" />
                                    <span class="file-upload-label">
                                        <span class="upload-icon">📎</span>
                                        <span class="upload-text">Choose file or drag here</span>
                                    </span>
                                </div>
                                <span id="fileName" class="file-name-display"></span>
                                <asp:RequiredFieldValidator ID="rfvStudentID" runat="server" 
                                    ControlToValidate="fuStudentID"
                                    InitialValue="" 
                                    ErrorMessage="Student ID Proof is required"
                                    Display="Dynamic"
                                    CssClass="field-validation-error" />
                            </div>
                        </div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="custom-checkbox">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="checkbox-input" />
                        <label for="<%= chkTerms.ClientID %>" class="checkbox-label">
                            I agree to the <a href="#" onclick="return false;">Terms and Conditions</a> and 
                            <a href="#" onclick="return false;">Privacy Policy</a>. 
                            I understand that my account will be verified by the admin team before I can access the platform.
                        </label>
                    </div>

                    <!-- Submit Button -->
                    <asp:Button ID="btnRegister" runat="server" CssClass="btn-register"
                        Text="Create Account" OnClick="btnRegister_Click" />

                    <!-- Login Link -->
                    <div class="login-link">
                        <p>Already have an account? <a href="Login.aspx">Sign In</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script type="text/javascript">
        // Display selected file name
        function displayFileName(input) {
            const fileNameSpan = document.getElementById('fileName');
            if (input.files && input.files[0]) {
                fileNameSpan.textContent = '📄 ' + input.files[0].name;
                fileNameSpan.style.display = 'block';
            } else {
                fileNameSpan.textContent = '';
                fileNameSpan.style.display = 'none';
            }
        }

        // Real-time password strength indicator
        document.addEventListener('DOMContentLoaded', function () {
            const passwordInput = document.getElementById('<%= txtPassword.ClientID %>');
            if (passwordInput) {
                passwordInput.addEventListener('input', function () {
                    const strength = calculatePasswordStrength(this.value);
                    // You can add visual feedback here if needed
                });
            }

            // File upload drag and drop
            const fileUpload = document.getElementById('<%= fuStudentID.ClientID %>');
            if (fileUpload) {
                const wrapper = fileUpload.closest('.file-upload-wrapper');

                ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
                    wrapper.addEventListener(eventName, preventDefaults, false);
                });

                function preventDefaults(e) {
                    e.preventDefault();
                    e.stopPropagation();
                }

                ['dragenter', 'dragover'].forEach(eventName => {
                    wrapper.addEventListener(eventName, () => {
                        wrapper.classList.add('drag-over');
                    }, false);
                });

                ['dragleave', 'drop'].forEach(eventName => {
                    wrapper.addEventListener(eventName, () => {
                        wrapper.classList.remove('drag-over');
                    }, false);
                });
            }
        });

        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/\d/.test(password)) strength++;
            if (/[^a-zA-Z\d]/.test(password)) strength++;
            return strength;
        }

        // Prevent form resubmission
        if (window.history.replaceState) {
            window.history.replaceState(null, null, window.location.href);
        }
    </script>
</asp:Content>