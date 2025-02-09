using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Lab7.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddLinkAndCommentModels : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "WSREF",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Url = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Minus = table.Column<int>(type: "int", nullable: false),
                    Plus = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WSREF", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "WSREFCOMMENT",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Wsref_id = table.Column<int>(type: "int", nullable: false),
                    Session_id = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Stamp = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Comtext = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WSREFCOMMENT", x => x.Id);
                    table.ForeignKey(
                        name: "FK_WSREFCOMMENT_WSREF_Wsref_id",
                        column: x => x.Wsref_id,
                        principalTable: "WSREF",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_WSREFCOMMENT_Wsref_id",
                table: "WSREFCOMMENT",
                column: "Wsref_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "WSREFCOMMENT");

            migrationBuilder.DropTable(
                name: "WSREF");
        }
    }
}
