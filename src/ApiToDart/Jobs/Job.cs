using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ApiToDart
{
    public class Job
    {
        public JobSettings Default { get; set; }

        /// <summary>
        /// Overrides for specific entities
        /// </summary>
        public List<JobOverride> Overrides { get; set; }

        public string RemoteSpecification { get; set; }

        public string SpecificationPath { get; set; }
    }
}