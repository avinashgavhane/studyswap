<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddCategory.aspx.cs" Inherits="StudySwap.Admin.AddCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Categories
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .category-container {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 30px;
            padding: 20px;
            background: #f9f9f9;
            border-radius: 12px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .card {
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 25px;
            border: 1px solid #e9ecef;
        }

        .card h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 1.4rem;
            color: #2c3e50;
            border-bottom: 2px solid #eaeaea;
            padding-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #495057;
            font-size: 0.9rem;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 0.95rem;
            box-sizing: border-box;
            transition: border 0.2s;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 6px;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
        }

        .btn:active {
            transform: scale(0.97);
        }

        .btn-primary {
            background: #3498db;
            color: white;
            width: 100%;
            padding: 12px;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-warning {
            background: #f39c12;
            color: white;
            padding: 6px 14px;
            font-size: 0.85rem;
        }

        .btn-warning:hover {
            background: #e67e22;
        }

        .btn-danger {
            background: #e74c3c;
            color: white;
            padding: 6px 14px;
            font-size: 0.85rem;
        }

        .btn-danger:hover {
            background: #c0392b;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
            padding: 6px 14px;
            font-size: 0.85rem;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        /* Table styles */
        .table-responsive {
            overflow-x: auto;
            max-height: 500px;
            overflow-y: auto;
        }

        .category-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .category-table th {
            background: #f1f3f5;
            color: #2c3e50;
            font-weight: 600;
            padding: 12px 10px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .category-table td {
            padding: 10px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .category-table tr:hover {
            background: #f8f9fa;
        }

        .category-table .actions {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .icon-preview {
            width: 28px;
            height: 28px;
            object-fit: contain;
            vertical-align: middle;
            margin-right: 6px;
        }

        .badge-active {
            background: #2ecc71;
            color: white;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .badge-inactive {
            background: #e74c3c;
            color: white;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .empty-message {
            text-align: center;
            color: #95a5a6;
            padding: 40px 10px;
            font-style: italic;
        }

        .edit-mode-indicator {
            background: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            margin-bottom: 15px;
            display: none;
        }

        .edit-mode-indicator.active {
            display: block;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .category-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="category-container">
        <!-- LEFT COLUMN: Add / Edit Form -->
        <div class="card">
            <h3>
                <span>📁</span>
                <asp:Label ID="lblFormTitle" runat="server" Text="Add New Category"></asp:Label>
            </h3>

            <div id="editModeIndicator" runat="server" class="edit-mode-indicator" visible="false">
                ✏️ You are editing an existing category.
            </div>

            <asp:Label ID="lblMessage" runat="server" EnableViewState="false" Font-Bold="true" ForeColor="Green" style="display:block; margin-bottom:10px;"></asp:Label>

            <!-- Hidden field for CategoryID (edit mode) -->
            <asp:HiddenField ID="hdnCategoryID" runat="server" />

            <div class="form-group">
                <label>Category Name *</label>
                <asp:TextBox ID="txtCategoryName" runat="server" placeholder="e.g. Books, Electronics..."></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCategoryName" runat="server"
                    ControlToValidate="txtCategoryName"
                    ErrorMessage="Category Name is required"
                    ForeColor="#e74c3c"
                    Display="Dynamic"
                    ValidationGroup="CategoryForm" />
            </div>

            <div class="form-group">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                    placeholder="Short description of the category..."></asp:TextBox>
            </div>

     

          

            <div class="form-group">
                <label>Active Status</label>
                <div class="checkbox-group">
                    <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" />
                    <span>Category is active</span>
                </div>
            </div>

            <asp:Button ID="btnSave" runat="server" Text="Add Category" CssClass="btn btn-primary"
                OnClick="btnSave_Click" ValidationGroup="CategoryForm" />

            <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel Edit" CssClass="btn btn-secondary"
                OnClick="btnCancelEdit_Click" Visible="false" style="margin-top:10px; width:100%;" />
        </div>

        <!-- RIGHT COLUMN: Category List -->
        <div class="card">
            <h3>
                <span>📋</span> Category List
            </h3>

            <div class="table-responsive">
                <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False"
                    CssClass="category-table" GridLines="None"
                    OnRowCommand="gvCategories_RowCommand"
                    DataKeyNames="CategoryID"
                    EmptyDataText="No categories found. Add your first category!">
                    <Columns>
                        <asp:TemplateField HeaderText="ID" ItemStyle-Width="50px">
                            <ItemTemplate>
                                <%# Eval("CategoryID") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Category">
                            <ItemTemplate>
                                
                                <strong><%# Eval("CategoryName") %></strong>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <%# Eval("Description") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                     

                        <asp:TemplateField HeaderText="Active" ItemStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Label ID="lblActive" runat="server"
                                    Text='<%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %>'
                                    CssClass='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge-active" : "badge-inactive" %>' />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="150px">
                            <ItemTemplate>
                                <div class="actions">
                                    <asp:LinkButton ID="btnEdit" runat="server"
                                        CommandName="EditCategory"
                                        CommandArgument='<%# Eval("CategoryID") %>'
                                        CssClass="btn btn-warning"
                                        Text="✏️ Edit"
                                        CausesValidation="false" />

                                    <asp:LinkButton ID="btnDelete" runat="server"
                                        CommandName="DeleteCategory"
                                        CommandArgument='<%# Eval("CategoryID") %>'
                                        CssClass="btn btn-danger"
                                        Text="🗑️ Delete"
                                        CausesValidation="false"
                                        OnClientClick="return confirm('Are you sure you want to delete this category?');" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>