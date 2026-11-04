<%@ Page Title="Manage Colleges" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddCollegeData.aspx.cs" Inherits="StudySwap.Admin.AddCollegeData" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Colleges
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-wrap {
            max-width: 1400px;
            margin: 25px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 18px 0;
            color: #222;
        }

        /* ---- 2-column layout ---- */
        .two-col {
            display: grid;
            grid-template-columns: 380px 1fr;   /* left fixed, right flexible */
            gap: 22px;
            align-items: start;
        }

        /* On smaller screens stack vertically */
        @media (max-width: 900px) {
            .two-col { grid-template-columns: 1fr; }
        }

        /* ---- Card style ---- */
        .card {
            background: #fff;
            border: 1px solid #e3e3e3;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .card h2 {
            margin: 0 0 16px 0;
            font-size: 17px;
            color: #0078d4;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 8px;
        }

        /* ---- Form ---- */
        .form-row { margin-bottom: 12px; }
        .form-row label {
            display: block;
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 4px;
            color: #333;
        }
        .form-row input[type=text],
        .form-row input[type=email] {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-row input[type=text]:focus,
        .form-row input[type=email]:focus {
            outline: none;
            border-color: #0078d4;
            box-shadow: 0 0 0 2px rgba(0,120,212,0.15);
        }

        .chk-row { margin: 14px 0; }
        .chk-row label { font-weight: 600; font-size: 13px; }

        .msg {
            display: block;
            margin: 10px 0 14px 0;
            font-weight: 600;
            font-size: 13px;
            padding: 8px 10px;
            border-radius: 5px;
            background: #f6f6f6;
        }
        .msg:empty { display: none; }

        /* ---- Buttons ---- */
        .btn-row { margin-top: 18px; }
        .btn {
            padding: 9px 20px;
            margin-right: 8px;
            background: #0078d4;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .btn:hover { background: #005a9e; }
        .btn-cancel { background: #888; }
        .btn-cancel:hover { background: #666; }

        /* ---- Grid ---- */
        .grid-wrap { overflow-x: auto; }
        .grid table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .grid th, .grid td {
            border: 1px solid #e1e1e1;
            padding: 8px 10px;
            text-align: left;
        }
        .grid th {
            background: #f5f7fa;
            color: #333;
            font-weight: 700;
        }
        .grid tr:nth-child(even) td { background: #fafbfc; }
        .grid tr:hover td { background: #eef6fd; }

        .grid a { color: #0078d4; text-decoration: none; font-weight: 600; }
        .grid a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="page-wrap">
    <h1 class="page-title">Manage Colleges</h1>

    <div class="two-col">

        <!-- ================= LEFT: Add / Edit form ================= -->
        <div class="card">
            <h2><asp:Literal ID="litFormTitle" runat="server" Text="Add New College" /></h2>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <asp:HiddenField ID="hfCollegeID" runat="server" Value="0" />

            <div class="form-row">
                <label>College Name</label>
                <asp:TextBox ID="txtCollegeName" runat="server" MaxLength="200" placeholder="Enter college name" />
            </div>
            <div class="form-row">
                <label>Email Domain</label>
                <asp:TextBox ID="txtEmailDomain" runat="server" MaxLength="100" placeholder="e.g. abc.edu" />
            </div>
            <div class="form-row">
                <label>City</label>
                <asp:TextBox ID="txtCity" runat="server" MaxLength="100" />
            </div>
            <div class="form-row">
                <label>State</label>
                <asp:TextBox ID="txtState" runat="server" MaxLength="100" />
            </div>

            <div class="chk-row">
                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" Text=" Is Active" />
            </div>

            <div class="btn-row">
                <asp:Button ID="btnSave" runat="server" Text="Save College"
                    CssClass="btn" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                    CssClass="btn btn-cancel" OnClick="btnCancel_Click"
                    CausesValidation="false" Visible="false" />
            </div>
        </div>

        <!-- ================= RIGHT: Grid ================= -->
        <div class="card">
            <h2>Existing Colleges</h2>

            <div class="grid-wrap grid">
                <asp:GridView ID="gvColleges" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="CollegeID" AllowPaging="True" PageSize="10"
                    GridLines="None"
                    OnPageIndexChanging="gvColleges_PageIndexChanging"
                    OnRowCommand="gvColleges_RowCommand"
                    OnRowDeleting="gvColleges_RowDeleting"
                    PagerStyle-HorizontalAlign="Center">
                    <Columns>
                        <asp:BoundField DataField="CollegeID"   HeaderText="ID" />
                        <asp:BoundField DataField="CollegeName" HeaderText="College Name" />
                        <asp:BoundField DataField="EmailDomain" HeaderText="Email Domain" />
                        <asp:BoundField DataField="City"        HeaderText="City" />
                        <asp:BoundField DataField="State"       HeaderText="State" />
                        <asp:CheckBoxField DataField="IsActive" HeaderText="Active" ReadOnly="true" />
                        <asp:BoundField DataField="CreatedDate" HeaderText="Created"
                            DataFormatString="{0:yyyy-MM-dd}" HtmlEncode="false" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    CommandName="EditCollege"
                                    CommandArgument='<%# Eval("CollegeID") %>'
                                    Text="Edit" />
                                &nbsp;|&nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandName="Delete"
                                    CommandArgument='<%# Eval("CollegeID") %>'
                                    Text="Delete"
                                    OnClientClick="return confirm('Delete this college?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</div>

</asp:Content>