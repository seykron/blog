/** Displays a list of github user's projects.
 * @param {Element} container Project list container. Cannot be null.
 * @param {String} userName Name of user to list projects from. Cannot be null.
 * @constructor
 */
Projects = function (container, userName) {

  /** Github API url relative to the user.
   * @constant
   * @private
   */
  var GH_API = "https://api.github.com/users/" + userName;

  /** Project template.
   * @constant
   * @private
   */
  var TEMPLATE = container.find(".js-project").html();

  /** Fetch github project list for my user.
   * @param {Function} callback Callback to receive the list of projects. Cannot
   *   be null.
   */
  var fetchProjects = function (callback) {
    jQuery.getJSON(GH_API + "/repos?callback=?", function (response) {
      callback(response.data);
    });
  };

  /** Renders the project into the container.
   * @param {Object} project Github project. Cannot be null.
   */
  var renderProject = function (project) {
    var projectEl = jQuery(TEMPLATE);
    projectEl.find(".js-link").text(project.name);
    projectEl.find(".js-link").attr("href", project.html_url);
    projectEl.find(".js-description").text(project.description);
    container.append(projectEl);
  };

  return {
    render: function () {
      fetchProjects(function (projects) {
        var i;
        for (i = 0; i < projects.length; i++) {
          if (!projects[i].fork) {
            renderProject(projects[i]);
          }
        }
      });
    }
  };
};

