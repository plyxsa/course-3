using Lab7.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Lab7.Data
{
    public class ApplicationDbContext : IdentityDbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
        public DbSet<WSREF> WSREF { get; set; }
        public DbSet<WSREFCOMMENT> WSREFCOMMENT { get; set; }
        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<WSREFCOMMENT>()
                .HasOne<WSREF>()
                .WithMany()
                .HasForeignKey(c => c.Wsref_id)
                .OnDelete(DeleteBehavior.Cascade);
        }

    }
    public class WSREF
    {
        public int Id { get; set; }
        public string Url { get; set; }
        public string Description { get; set; }
        public int Minus { get; set; }
        public int Plus { get; set; }
    }
    public class WSREFCOMMENT
    {
        public int Id { get; set; }
        public int Wsref_id { get; set; }
        public string Session_id { get; set; }
        public DateTime Stamp { get; set; }
        public string Comtext { get; set; }
    }

}
