<%@ Page Title="My Complaints" Language="C#" MasterPageFile="~/Student/Student.Master" AutoEventWireup="true" CodeBehind="Complains.aspx.cs" Inherits="StudySwap.Student.Complains" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-wrap { max-width: 1400px; margin: 25px auto; padding: 0 20px; }
        .page-title { font-size: 22px; font-weight: 700; margin: 0 0 18px 0; color: #222; }

        /* ---- Two-column layout ---- */
        .two-col {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 22px;
            align-items: start;
        }
        @media (max-width: 900px) { .two-col { grid-template-columns: 1fr; } }

        /* ---- Card ---- */
        .card {
            background: #fff; border: 1px solid #e3e3e3; border-radius: 10px;
            padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .card h2 {
            margin: 0 0 16px 0; font-size: 17px; color: #0078d4;
            border-bottom: 2px solid #f0f0f0; padding-bottom: 8px;
        }

        /* ---- Form ---- */
        .form-row { margin-bottom: 12px; }
        .form-row label {
            display: block; font-weight: 600; font-size: 13px;
            margin-bottom: 4px; color: #333;
        }
        .form-row input[type=text],
        .form-row select,
        .form-row textarea {
            width: 100%; padding: 8px 10px; border: 1px solid #ccc;
            border-radius: 5px; font-size: 14px; box-sizing: border-box;
            font-family: inherit;
        }
        .form-row textarea { resize: vertical; min-height: 80px; }
        .form-row input:focus, .form-row select:focus, .form-row textarea:focus {
            outline: none; border-color: #0078d4;
            box-shadow: 0 0 0 2px rgba(0,120,212,0.15);
        }

        .msg { display: block; margin: 10px 0 14px 0; font-weight: 600;
               font-size: 13px; padding: 8px 10px; border-radius: 5px;
               background: #f6f6f6; }
        .msg:empty { display: none; }

        /* ---- Buttons ---- */
        .btn-row { margin-top: 18px; }
        .btn {
            padding: 9px 20px; margin-right: 8px; background: #0078d4; color: #fff;
            border: none; border-radius: 5px; cursor: pointer;
            font-size: 14px; font-weight: 600;
        }
        .btn:hover { background: #005a9e; }
        .btn-cancel { background: #888; }
        .btn-cancel:hover { background: #666; }

        /* ---- Grid ---- */
        .grid-wrap { overflow-x: auto; }
        .grid table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .grid th, .grid td {
            border: 1px solid #e1e1e1; padding: 8px 10px;
            text-align: left; vertical-align: top;
        }
        .grid th { background: #f5f7fa; color: #333; font-weight: 700; white-space: nowrap; }
        .grid tr:nth-child(even) td { background: #fafbfc; }
        .grid tr:hover td { background: #eef6fd; }
        .grid a { color: #0078d4; text-decoration: none; font-weight: 600; }
        .grid a:hover { text-decoration: underline; }
        .grid a.delete { color: #d32f2f; }

        .desc-cell { max-width: 320px; word-wrap: break-word; }
        .resp-cell { max-width: 260px; word-wrap: break-word; color: #166534; }

        /* ---- Badges ---- */
        .badge {
            display: inline-block; padding: 3px 9px; border-radius: 12px;
            font-size: 11px; font-weight: 700; text-transform: uppercase;
        }
        .badge-open       { background: #fef3c7; color: #92400e; }
        .badge-inprogress { background: #dbeafe; color: #1e40af; }
        .badge-resolved   { background: #dcfce7; color: #166534; }
        .badge-closed     { background: #f3f4f6; color: #4b5563; }
        .badge-rejected   { background: #fee2e2; color: #991b1b; }

        .prio { display: inline-block; padding: 2px 8px; border-radius: 10px;
                font-size: 11px; font-weight: 700; }
        .prio-low    { background: #f3f4f6; color: #4b5563; }
        .prio-medium { background: #e0e7ff; color: #3730a3; }
        .prio-high   { background: #fde68a; color: #92400e; }
        .prio-urgent { background: #fecaca; color: #991b1b; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="page-wrap">
    <h1 class="page-title">My Complaints</h1>

    <div class="two-col">

        <!-- ============ LEFT: Add / Edit form ============ -->
        <div class="card">
            <h2><asp:Literal ID="litFormTitle" runat="server" Text="Raise a Complaint" /></h2>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <asp:HiddenField ID="hfComplaintID" runat="server" Value="0" />

            <div class="form-row">
                <label>Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server">
                    <asp:ListItem Text="-- Select --" Value="" />
                    <asp:ListItem Text="Listing"    Value="Listing" />
                    <asp:ListItem Text="User"       Value="User" />
                    <asp:ListItem Text="Payment"    Value="Payment" />
                    <asp:ListItem Text="Technical"  Value="Technical" />
                    <asp:ListItem Text="Other"      Value="Other" />
                </asp:DropDownList>
            </div>

            <div class="form-row">
                <label>Subject</label>
                <asp:TextBox ID="txtSubject" runat="server" MaxLength="200"
                    placeholder="Brief summary" />
            </div>

            <div class="form-row">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                    Rows="5" MaxLength="2000" placeholder="Explain your issue in detail..." />
            </div>

            <div class="form-row">
                <label>Priority</label>
                <asp:DropDownList ID="ddlPriority" runat="server">
                    <asp:ListItem Text="Low"    Value="Low" />
                    <asp:ListItem Text="Medium" Value="Medium" Selected="True" />
                    <asp:ListItem Text="High"   Value="High" />
                    <asp:ListItem Text="Urgent" Value="Urgent" />
                </asp:DropDownList>
            </div>

            <div class="btn-row">
                <asp:Button ID="btnSave" runat="server" Text="Submit Complaint"
                    CssClass="btn" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                    CssClass="btn btn-cancel" OnClick="btnCancel_Click"
                    CausesValidation="false" Visible="false" />
            </div>
        </div>

        <!-- ============ RIGHT: Complaints grid ============ -->
        <div class="card">
            <h2>My Complaint History</h2>

            <div class="grid-wrap grid">
                <asp:GridView ID="gvComplaints" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="ComplaintID" AllowPaging="True" PageSize="10"
                    GridLines="None"
                    OnPageIndexChanging="gvComplaints_PageIndexChanging"
                    OnRowCommand="gvComplaints_RowCommand"
                    OnRowDeleting="gvComplaints_RowDeleting"
                    PagerStyle-HorizontalAlign="Center">
                    <Columns>
                        <asp:BoundField DataField="ComplaintID" HeaderText="ID" />
                        <asp:BoundField DataField="Category"    HeaderText="Category" />

                        <asp:TemplateField HeaderText="Subject">
                            <ItemTemplate>
                                <strong><%# Eval("Subject") %></strong><br />
                                <span class="desc-cell"><%# Eval("Description") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Priority">
                            <ItemTemplate>
                                <span class='<%# GetPriorityClass(Eval("Priority")) %>'>
                                    <%# Eval("Priority") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Admin Response">
                            <ItemTemplate>
                                <span class="resp-cell">
                                    <%# string.IsNullOrEmpty(Convert.ToString(Eval("AdminResponse")))
                                            ? "—" : Eval("AdminResponse") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CreatedDate" HeaderText="Raised On"
                            DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    CommandName="EditComplaint"
                                    CommandArgument='<%# Eval("ComplaintID") %>'
                                    Text="Edit"
                                    Visible='<%# CanEdit(Eval("Status")) %>' />
                                <asp:Label ID="lblNoEdit" runat="server" Text="—"
                                    Visible='<%# !CanEdit(Eval("Status")) %>' />
                                &nbsp;|&nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CssClass="delete"
                                    CommandName="Delete"
                                    CommandArgument='<%# Eval("ComplaintID") %>'
                                    Text="Delete"
                                    Visible='<%# CanDelete(Eval("Status")) %>'
                                    OnClientClick="return confirm('Delete this complaint?');" />
                                <asp:Label ID="lblNoDelete" runat="server" Text="—"
                                    Visible='<%# !CanDelete(Eval("Status")) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <p style="padding:20px;text-align:center;color:#888;">
                            You haven't raised any complaints yet.
                        </p>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</div>

</asp:Content>