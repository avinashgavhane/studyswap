<%@ Page Title="Forgot Password" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="~/ForgotPassword.aspx.cs"
    Inherits="StudySwap.ForgotPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .fp-wrap { max-width: 460px; margin: 60px auto; padding: 30px;
            background: #fff; border-radius: 12px; box-shadow: 0 4px 18px rgba(0,0,0,.08); }
        .fp-wrap h2 { margin-bottom: 8px; color: #1f2937; }
        .fp-wrap p.sub { color: #6b7280; font-size: 14px; margin-bottom: 24px; }
        .fp-field { margin-bottom: 16px; }
        .fp-field label { display: block; font-weight: 600; margin-bottom: 6px; color: #374151; font-size: 14px; }
        .fp-field input { width: 100%; padding: 11px 12px; border: 1px solid #d1d5db;
            border-radius: 8px; font-size: 14px; box-sizing: border-box; }
        .fp-field input:focus { outline: none; border-color: #4f46e5; }
        .fp-btn { width: 100%; padding: 12px; background: #4f46e5; color: #fff;
            border: none; border-radius: 8px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .fp-btn:hover { background: #4338ca; }
        .fp-msg { padding: 12px 14px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; display: block; }
        .fp-ok { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .fp-err { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .fp-verified-box { margin-bottom: 18px; padding: 12px; background: #eff6ff; border: 1px solid #bfdbfe; border-radius: 8px; color: #1e40af; font-size: 14px; }
        .link { text-align: center; margin-top: 18px; font-size: 14px; }
        .link a { color: #4f46e5; text-decoration: none; font-weight: 500; }
        .link a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<div class="fp-wrap">
    <h2>Reset Password</h2>
    <p class="sub">Verify your student identity to reset your password.</p>

    <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="fp-msg"></asp:Label>

    <!-- Hidden field carries verified email between steps -->
    <asp:HiddenField ID="hfEmail" runat="server" />

    <!-- STEP 1: Verify Student Email & Roll Number -->
    <asp:Panel ID="pnlEmail" runat="server">
        <div class="fp-field">
            <label>Registered Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                placeholder="e.g. student@college.edu" ValidationGroup="vgVerify"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Email is required" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgVerify" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtEmail"
                ErrorMessage="Enter a valid email address" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgVerify"
                ValidationExpression="\w+([-+.'']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" />
        </div>
        <div class="fp-field">
            <label>College Roll Number</label>
            <asp:TextBox ID="txtRollNumber" runat="server"
                placeholder="e.g. 101 or CS-2024" ValidationGroup="vgVerify"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtRollNumber"
                ErrorMessage="Roll Number is required for verification" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgVerify" />
        </div>
        <asp:Button ID="btnCheckEmail" runat="server" Text="Verify Identity"
            CssClass="fp-btn" OnClick="btnCheckEmail_Click" ValidationGroup="vgVerify" />
    </asp:Panel>

    <!-- STEP 2: Set New Password -->
    <asp:Panel ID="pnlReset" runat="server" Visible="false">
        <div class="fp-verified-box">
            <asp:Label ID="lblGreeting" runat="server"></asp:Label>
        </div>
        <div class="fp-field">
            <label>New Password</label>
            <asp:TextBox ID="txtNewPass" runat="server" TextMode="Password"
                placeholder="Minimum 8 characters" ValidationGroup="vgReset"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtNewPass"
                ErrorMessage="New password is required" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgReset" />
            <asp:RegularExpressionValidator runat="server" ControlToValidate="txtNewPass"
                ErrorMessage="Password must be at least 8 characters" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgReset" ValidationExpression="^.{8,}$" />
        </div>
        <div class="fp-field">
            <label>Confirm New Password</label>
            <asp:TextBox ID="txtConfirmPass" runat="server" TextMode="Password"
                placeholder="Re-enter your new password" ValidationGroup="vgReset"></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtConfirmPass"
                ErrorMessage="Please confirm your new password" ForeColor="Red" Display="Dynamic"
                ValidationGroup="vgReset" />
            <asp:CompareValidator runat="server" ControlToValidate="txtConfirmPass"
                ControlToCompare="txtNewPass" ErrorMessage="Passwords do not match"
                ForeColor="Red" Display="Dynamic" ValidationGroup="vgReset" />
        </div>
        <asp:Button ID="btnReset" runat="server" Text="Save New Password"
            CssClass="fp-btn" OnClick="btnReset_Click" ValidationGroup="vgReset" />
    </asp:Panel>

    <div class="link">
        <a href="Login.aspx">&larr; Back to Login</a>
    </div>
</div>
</asp:Content>
