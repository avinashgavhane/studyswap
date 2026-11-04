<%@ Page Title="All Purchase Requests" Language="C#" 
    MasterPageFile="~/Student/Student.Master" 
    AutoEventWireup="true" 
    CodeBehind="ViewAllPurchaseRequest.aspx.cs" 
    Inherits="StudySwap.Student.ViewAllPurchaseRequest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .request-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
            padding: 32px 30px;
            margin-bottom: 25px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .request-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.16);
        }
        h4 {
            color: #1f2937;
            font-weight: 700;
        }
        p {
            color: #4b5563;
            font-size: 15px;
            margin-bottom: 12px;
        }
        .status-badge {
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 22px;
            color: white;
            font-size: 13px;
            user-select: none;
            display: inline-block;
            margin-bottom: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .status-open { background-color: #0ea5e9; }
        .status-closed { background-color: #22c55e; }

        /* Optional: show requester name */
        .requester-name {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 15px;
            font-style: italic;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h3 class="mb-4" style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">All Purchase Requests</h3>

<asp:Repeater ID="rptAllRequests" runat="server"
    OnItemCommand="rptAllRequests_ItemCommand">
    <ItemTemplate>
            <div class="request-card" role="region" aria-label="Purchase Request">
                <h4><%# Eval("ItemName") %></h4>
                <p><%# Eval("Description") %></p>

                <span class="status-badge 
                    <%# Eval("Status").ToString().ToLower() == "open" ? "status-open" : "status-closed" %>">
                    <%# Eval("Status") %>
                </span>

                <div class="requester-name">
                    Requested by: <%# Eval("RequesterName") %>
                </div>
<asp:Button 
    ID="btnReply"
    runat="server"
    CssClass="btn btn-success"
    Text="I have this product"
    CommandName="Reply"
    CommandArgument='<%# Eval("PurchaseRequestID") %>' />
            </div>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Label ID="lblNoRequests" runat="server" Text="No purchase requests found." 
        Visible="false" CssClass="text-muted" style="font-style: italic; font-size: 16px;"></asp:Label>
</asp:Content>
