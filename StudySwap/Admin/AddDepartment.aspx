<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddDepartment.aspx.cs" Inherits="StudySwap.Admin.AddDepartment" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Add / Manage Departments
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .dept-container {
            display: flex;
            gap: 30px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        .dept-form-panel {
            flex: 0 0 380px;
            background: #f9f9f9;
            border-radius: 12px;
            padding: 25px 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #eaeaea;
        }
        .dept-list-panel {
            flex: 1;
            min-width: 500px;
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #eaeaea;
            overflow-x: auto;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            color: #2c3e50;
            font-size: 0.9rem;
        }
        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: 0.2s;
            box-sizing: border-box;
        }
        .form-control:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 0 3px rgba(52,152,219,0.15);
        }
        .checkbox-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 8px;
        }
        .checkbox-row input[type="checkbox"] {
            width: 18px;
            height: 18px;
            margin: 0;
        }
        .btn {
            padding: 10px 22px;
            border-radius: 8px;
            font-weight: 600;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            transition: 0.2s;
            display: inline-block;
        }
        .btn-primary {
            background: #3498db;
            color: white;
        }
        .btn-primary:hover {
            background: #2980b9;
        }
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        .btn-warning:hover {
            background: #e67e22;
        }
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        .btn-danger:hover {
            background: #c0392b;
        }
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 6px;
        }
        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        .table-responsive {
            width: 100%;
            overflow-x: auto;
        }
        .dept-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        .dept-table th {
            background: #2c3e50;
            color: white;
            padding: 12px 10px;
            text-align: left;
            font-weight: 600;
            white-space: nowrap;
        }
        .dept-table td {
            padding: 10px;
            border-bottom: 1px solid #eee;
            vertical-align: middle;
        }
        .dept-table tr:hover td {
            background: #f8f9fa;
        }
        .badge-active {
            background: #27ae60;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            white-space: nowrap;
        }
        .badge-inactive {
            background: #e74c3c;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            white-space: nowrap;
        }
        .empty-message {
            text-align: center;
            padding: 40px 20px;
            color: #7f8c8d;
            font-style: italic;
        }
        .search-box {
            margin-bottom: 15px;
            display: flex;
            gap: 10px;
        }
        .search-box input {
            flex: 1;
            padding: 10px 14px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 0.95rem;
        }
        .message-alert {
            padding: 12px 18px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: 500;
            display: block;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 5px solid #27ae60;
        }
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 5px solid #e74c3c;
        }
        .college-dropdown {
            max-width: 100%;
        }
        .dept-list-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        .dept-list-header h3 {
            margin: 0;
            color: #2c3e50;
            font-size: 1.3rem;
        }
        .record-count {
            color: #7f8c8d;
            font-size: 0.9rem;
            background: #ecf0f1;
            padding: 4px 12px;
            border-radius: 20px;
        }
        @media (max-width: 1000px) {
            .dept-container {
                flex-direction: column;
            }
            .dept-form-panel {
                flex: 1 1 auto;
            }
            .dept-list-panel {
                min-width: 0;
            }
        }
        .compact-grid {
            margin-top: 0 !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <h2 style="color:#2c3e50; margin-bottom: 6px;">Department Management</h2>
        <p style="color:#7f8c8d; margin-bottom: 20px;">Add, edit or delete departments. Each department belongs to a college.</p>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="message-alert" />

        <div class="dept-container">
            <!-- LEFT: Add / Edit Form -->
            <div class="dept-form-panel">
                <h3 style="margin-top:0; color:#2c3e50; font-size:1.2rem; border-bottom:2px solid #3498db; padding-bottom:12px;">
                    <asp:Literal ID="litFormTitle" runat="server" Text="Add New Department" />
                </h3>

                <asp:HiddenField ID="hfDepartmentID" runat="server" Value="0" />

                <div class="form-group">
                    <label>College <span style="color:red;">*</span></label>
                    <asp:DropDownList ID="ddlCollege" runat="server" CssClass="form-control college-dropdown"
                        AutoPostBack="false" DataTextField="CollegeName" DataValueField="CollegeID">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCollege" runat="server" ControlToValidate="ddlCollege"
                        InitialValue="0" ErrorMessage="Please select a college." ForeColor="#e74c3c"
                        Display="Dynamic" ValidationGroup="DeptValidation" Font-Size="Small" />
                </div>

                <div class="form-group">
                    <label>Department Name <span style="color:red;">*</span></label>
                    <asp:TextBox ID="txtDepartmentName" runat="server" CssClass="form-control"
                        MaxLength="100" placeholder="e.g. Computer Engineering" />
                    <asp:RequiredFieldValidator ID="rfvDepartmentName" runat="server" ControlToValidate="txtDepartmentName"
                        ErrorMessage="Department name is required." ForeColor="#e74c3c"
                        Display="Dynamic" ValidationGroup="DeptValidation" Font-Size="Small" />
                </div>

                <div class="form-group">
                    <label>Department Code</label>
                    <asp:TextBox ID="txtDepartmentCode" runat="server" CssClass="form-control"
                        MaxLength="20" placeholder="e.g. CSE" />
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <div class="checkbox-row">
                        <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                        <span style="font-size:0.95rem; color:#2c3e50;">Active (visible for selection)</span>
                    </div>
                </div>

                <div style="display:flex; gap:12px; flex-wrap:wrap; margin-top:25px;">
                    <asp:Button ID="btnSave" runat="server" Text="Save Department" CssClass="btn btn-primary"
                        OnClick="btnSave_Click" ValidationGroup="DeptValidation" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary"
                        OnClick="btnCancel_Click" Visible="false" CausesValidation="false" />
                </div>
            </div>

            <!-- RIGHT: List with Edit/Delete -->
            <div class="dept-list-panel">
                <div class="dept-list-header">
                    <h3>All Departments</h3>
                    <span class="record-count">
                        <asp:Literal ID="litRecordCount" runat="server" Text="0" /> records
                    </span>
                </div>

                <div class="search-box">
                    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search by department name or code..." />
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                        OnClick="btnSearch_Click" CausesValidation="false" />
                    <asp:Button ID="btnClearSearch" runat="server" Text="Clear" CssClass="btn btn-secondary"
                        OnClick="btnClearSearch_Click" CausesValidation="false" />
                </div>

                <div class="table-responsive">
                    <asp:GridView ID="gvDepartments" runat="server" AutoGenerateColumns="false"
                        CssClass="dept-table" GridLines="None" AllowPaging="true" PageSize="15"
                        OnPageIndexChanging="gvDepartments_PageIndexChanging"
                        OnRowCommand="gvDepartments_RowCommand"
                        EmptyDataText="No departments found. Add one using the form.">
                        <Columns>
                            <asp:TemplateField HeaderText="ID" ItemStyle-Width="50px">
                                <ItemTemplate>
                                    <%# Eval("DepartmentID") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="College">
                                <ItemTemplate>
                                    <%# Eval("CollegeName") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Department Name">
                                <ItemTemplate>
                                    <strong><%# Eval("DepartmentName") %></strong>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Code" ItemStyle-Width="90px">
                                <ItemTemplate>
                                    <%# string.IsNullOrEmpty(Eval("DepartmentCode").ToString()) ? "—" : Eval("DepartmentCode") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="90px">
                                <ItemTemplate>
                                    <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>'>
                                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                                <ItemTemplate>
                                    <div class="action-buttons">
                                        <asp:LinkButton ID="btnEdit" runat="server" Text="Edit"
                                            CssClass="btn btn-warning btn-sm"
                                            CommandName="EditDept"
                                            CommandArgument='<%# Eval("DepartmentID") %>'
                                            CausesValidation="false" />
                                        <asp:LinkButton ID="btnDelete" runat="server" Text="Delete"
                                            CssClass="btn btn-danger btn-sm"
                                            CommandName="DeleteDept"
                                            CommandArgument='<%# Eval("DepartmentID") %>'
                                            OnClientClick="return confirm('Are you sure you want to delete this department?');"
                                            CausesValidation="false" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <PagerStyle CssClass="pagination" HorizontalAlign="Center" />
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>
</asp:Content>