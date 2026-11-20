<%@ Page Title="Edit Profile" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="EditProfile.aspx.cs"
    Inherits="StudySwap.Student.EditProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="/Content/bootstrap5.min.css" rel="stylesheet" />
    <link href="/Content/bootstrap-icons.css" rel="stylesheet" />

    <style>
        body {
            background: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .profile-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
            padding: 20px 25px;
            max-width: 700px;
            margin: auto;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px;
            padding: 15px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .profile-img {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            border: 3px solid white;
            object-fit: cover;
        }

        .section-title {
            font-weight: 700;
            margin-top: 15px;
            margin-bottom: 12px;
            border-left: 4px solid #667eea;
            padding-left: 8px;
            color: #333;
            font-size: 1.1rem;
        }

        .form-control, .form-select {
            border-radius: 10px;
            font-size: 0.9rem;
            padding: 6px 10px;
            height: 35px;
        }

        label.form-label {
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .save-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 14px;
            padding: 10px 30px;
            font-weight: 700;
            font-size: 1rem;
            min-width: 160px;
        }

        .save-btn:hover { opacity: 0.9; }

        .badge-status {
            background: #198754;
            font-size: 0.85rem;
            padding: 0.25em 0.6em;
        }

        img.profile-img.mt-2 {
            width: 90px !important;
            height: 90px !important;
            margin-top: 8px !important;
            border-radius: 12px !important;
        }

        .text-center.mt-4 { margin-top: 20px !important; }

        /* --- NEW: password section --- */
        .password-divider {
            margin: 22px 0 10px;
            border-top: 1px dashed #d1d5db;
        }
        .pwd-msg {
            font-size: 0.85rem;
            margin-top: 6px;
            display: block;
        }
        .pwd-msg.ok { color: #198754; }
        .pwd-msg.err { color: #dc3545; }
    
        /* --- WhatsApp Privacy Switch --- */
        .wa-switch-card {
            background: #f0fdf4;
            border: 1px solid #bbf7d0;
            border-radius: 14px;
            padding: 14px 18px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
            transition: all 0.2s ease;
        }
        .wa-switch-card:hover {
            border-color: #86efac;
            background: #ecfdf5;
        }
        .switch-toggle {
            position: relative;
            display: inline-block;
            width: 48px;
            height: 26px;
            flex-shrink: 0;
            margin-top: 2px;
            cursor: pointer;
        }
        .switch-toggle input[type="checkbox"] {
            opacity: 0 !important;
            width: 0 !important;
            height: 0 !important;
            position: absolute !important;
            margin: 0 !important;
            pointer-events: none !important;
        }
        .switch-toggle span.form-check-input,
        .switch-toggle span:not(.switch-slider) {
            border: none !important;
            background: transparent !important;
            padding: 0 !important;
            margin: 0 !important;
            box-shadow: none !important;
            display: contents !important;
        }
        .switch-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #cbd5e1;
            transition: 0.25s ease;
            border-radius: 26px;
        }
        .switch-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.25s ease;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.25);
        }
        .switch-toggle input:checked + .switch-slider,
        .switch-toggle input:checked ~ .switch-slider,
        .switch-toggle:has(input:checked) .switch-slider {
            background-color: #25D366;
        }
        .switch-toggle input:checked + .switch-slider:before,
        .switch-toggle input:checked ~ .switch-slider:before,
        .switch-toggle:has(input:checked) .switch-slider:before {
            transform: translateX(22px);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="container py-4">
    <div class="profile-card">

        <!-- HEADER -->
        <div class="profile-header d-flex align-items-center">
            <asp:Image ID="imgHeaderProfile" runat="server" CssClass="profile-img me-4" />
            <div>
                <h4 class="mb-1">Edit Student Profile</h4>
                <span class="badge badge-status">Verified Student</span>
            </div>
        </div>

        <!-- BASIC INFO -->
        <div class="section-title">Basic Information</div>

        <div class="row g-3">
            <div class="col-md-6">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" />
            </div>

            <div class="col-md-6">
                <label class="form-label">Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true" />
            </div>

            <div class="col-md-6">
                <label class="form-label">Phone</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" />
            </div>

                        <div class="col-md-6">
                <label class="form-label">Roll Number</label>
                <asp:TextBox ID="txtRoll" runat="server" CssClass="form-control" />
            </div>

                        <div class="col-12 mt-3">
                <div class="wa-switch-card">
                    <label class="switch-toggle" for="chkAllowWhatsApp" title="Toggle WhatsApp Chat">
                        <asp:CheckBox ID="chkAllowWhatsApp" runat="server" ClientIDMode="Static" />
                        <span class="switch-slider"></span>
                    </label>
                    <div class="flex-grow-1">
                        <label for="chkAllowWhatsApp" class="d-block mb-1" style="font-weight:600; color:#166534; cursor:pointer;">
                            <i class="bi bi-whatsapp me-1" style="color:#25D366; font-size:1.15rem; vertical-align:middle;"></i> Allow WhatsApp Chat
                        </label>
                        <div class="small" style="color:#15803d; line-height:1.4;">
                            Enable this to display a "Chat on WhatsApp" button on your listings so verified students can reach out to you directly.
                        </div>
                    </div>
                </div>
            </div></div>
        </div>

        <!-- ACADEMIC INFO -->
        <div class="section-title">Academic Details</div>

        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label">College</label>
                <asp:DropDownList ID="ddlCollege" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-4">
                <label class="form-label">Department</label>
                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="form-select" />
            </div>

            <div class="col-md-4">
                <label class="form-label">Year of Study</label>
                <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select" />
            </div>
        </div>

        <!-- PROFILE IMAGE -->
        <div class="section-title">Images</div>

        <div class="row g-3 align-items-center">
            <div class="col-md-6 text-center">
                <label class="form-label d-block">Profile Picture</label>
                <asp:Image ID="imgProfile" runat="server" CssClass="profile-img mx-auto" Visible="false" />
                <asp:FileUpload ID="fuProfile" runat="server" CssClass="form-control mt-2" />
            </div>

            <div class="col-md-6 text-center">
                <label class="form-label d-block">Student ID Proof</label>
                <asp:Image ID="imgIDProof" runat="server" CssClass="profile-img" Style="width:90px; height:auto;" Visible="false" />
                <asp:FileUpload ID="fuIDProof" runat="server" CssClass="form-control mt-2" />
            </div>
        </div>

        <!-- ================= NEW: CHANGE PASSWORD ================= -->
        <div class="password-divider"></div>
        <div class="section-title">Change Password</div>

        <div class="row g-3">
            <div class="col-12">
                <label class="form-label">Current Password</label>
                <asp:TextBox ID="txtCurrentPwd" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Enter current password" />
            </div>

            <div class="col-md-6">
                <label class="form-label">New Password</label>
                <asp:TextBox ID="txtNewPwd" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Min 8 characters" />
            </div>

            <div class="col-md-6">
                <label class="form-label">Confirm New Password</label>
                <asp:TextBox ID="txtConfirmPwd" runat="server" CssClass="form-control"
                    TextMode="Password" placeholder="Re-enter new password" />
            </div>

            <div class="col-12">
                <asp:Button ID="btnChangePassword" runat="server"
                    Text="Update Password"
                    CssClass="btn save-btn"
                    OnClick="btnChangePassword_Click" />
                <asp:Label ID="lblPwdStatus" runat="server" CssClass="pwd-msg" Visible="false"></asp:Label>
            </div>
        </div>
        <!-- ======================================================= -->

        <!-- SAVE -->
        <div class="text-center mt-4">
            <asp:Button ID="btnSave" runat="server"
                Text="Save Changes"
                CssClass="btn save-btn" OnClick="btnSave_Click" />
        </div>
        <asp:Label ID="lblStatus" runat="server" Text="Label" Visible="false"></asp:Label>
    </div>
</div>

</asp:Content>
