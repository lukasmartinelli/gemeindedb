$(function () {
    Highcharts.theme = {
        colors: ['#006699', '#66afe9', '#D8E8EF', '#757575', '#DC0018', '#fffab2',  '##F7001D'],
        chart: {
            backgroundColor: {
                linearGradient: [0, 0, 500, 500],
                stops: [
                    [0, 'rgb(255, 255, 255)'],
                    [1, 'rgb(240, 240, 255)']
                ]
            },
        },
        title: {
            style: {
                color: '#454545',
                font: '16px "Open Sans", sans-serif'
            }
        },
        subtitle: {
            style: {
                color: '#454545',
                font: '12px "Open Sans", sans-serif'
            }
        },

        legend: {
            itemStyle: {
                color: '454545',
                font: '9pt Open Sans, sans-serif'
            },
            itemHoverStyle:{
                color: 'gray'
            }
        }
    };
    Highcharts.setOptions(Highcharts.theme);

    function negate(number) {
        return -number;
    }

    function partyShareDiagram(elem, data) {
        function getVoters(r) { return r.voters; }
        function filterParty(party) {
            return function(r) {
                return r.party == party;
            }
        }
        var years = $.unique($.map(data.political_parties, function(record) { return record.year; }));

        var sp = $.map(data.political_parties.filter(filterParty('SP/PS')), getVoters);
        var cvp = $.map(data.political_parties.filter(filterParty('CVP/PDC')), getVoters);
        var fdp = $.map(data.political_parties.filter(filterParty('FDP/PLR (PRD)')), getVoters);
        var glp = $.map(data.political_parties.filter(filterParty('GLP/PVL')), getVoters);
        var svp = $.map(data.political_parties.filter(filterParty('SVP/UDC')), getVoters);
        var bdp = $.map(data.political_parties.filter(filterParty('BDP/PBD')), getVoters);
        var gps = $.map(data.political_parties.filter(filterParty('GPS/PES')), getVoters);
        var other = $.map(data.political_parties.filter(filterParty('Other')), getVoters);

        $(elem).highcharts({
            chart: { type: 'area' },
            title: { text: 'Share of Political Parties' },
            xAxis: { categories: years },
            yAxis: {
                title: { text: 'Percentage' }
            },
            tooltip: {
                pointFormat: '<span>{series.name}</span>: <b>{point.percentage:.1f}%</b> ({point.y:,.0f})<br/>'
            },
            plotOptions: {
                area: { stacking: 'percent' }
            },
            colors: ['#D8E8EF', '#006400', '#CC0000', '#007AD2', '#DB8300', '#66BB66', '#A2BB00', '#FBD81B', '#757575', '#454545', '#DB9200', '#354F00', '#7A9F35', '#C20C0C'],
            series: [{
                name: 'Übrige/Autres',
                data: other
            }, {
                name: 'SVP/UDP',
                data: svp
            }, {
                name: 'SP/PES',
                data: sp
            }, {
                name: 'FDP/PLR',
                data: fdp
            }, {
                name: 'CVP/PDC',
                data: cvp
            }, {
                name: 'GPS/PES',
                data: gps
            }, {
                name: 'GLP/PVL',
                data: glp
            }, {
                name: 'BDP',
                data: bdp
            }]
        });
    };

    function birthDeathDiagram(elem, data) {
        var births = $.map(data.births, function(record) { return record.births; });
        var deaths = $.map(data.deaths, function(record) { return record.deaths; });
        var birthSurplus = $.map(data.birth_surplus, function(record) { return record.surplus; });
        var years = $.map(data.births, function(record) { return record.year; });

        $(elem).highcharts({
            chart: { type: 'area' },
            title: { text: 'Births and Deaths' },
            xAxis: { categories: years },
            yAxis: {
                title: { text: 'People' }
            },
            plotOptions: {
                column: { stacking: 'normal' }
            },
            series: [{
                name: 'Births',
                type: 'column',
                data: births
            }, {
                name: 'Deaths',
                type: 'column',
                data: $.map(deaths, negate)
            }, {
                name: 'Birth Surplus',
                type: 'spline',
                dashStyle: 'shortdot',
                color: '#DC0018',
                data: birthSurplus
            }]
        });
    };

    function migrationDiagram(elem, data) {
        function getImmigration(r) { return r.immigration }
        function getEmigration(r) { return r.emigration }

        var years = $.map(data.births, function(record) { return record.year; });
        var immigrationSameCanton = $.map(data.immigration_from_same_canton, getImmigration);
        var immigrationOtherCanton = $.map(data.immigration_from_other_canton, getImmigration);
        var emigrationSameCanton = $.map(data.emigration_from_same_canton, getEmigration);
        var emigrationOtherCanton = $.map(data.emigration_from_other_canton, getEmigration);
        var migrationBalance = $.map(data.migration_balance, function(r) { return r.balance; });

        $(elem).highcharts({
            chart: { type: 'column' },
            title: { text: 'Emigration' },
            xAxis: {
              categories: years,
            },
            yAxis: {
                title: { text: 'People' }
            },
            plotOptions: {
                column: { stacking: 'normal' }
            },
            colors: ['#006699', '#66afe9', '#757575', '#454545'],
            series: [{
                name: 'Immigration Same Canton',
                data: immigrationSameCanton
            }, {
                name: 'Immigration Other Canton',
                data: immigrationOtherCanton
            }, {
                name: 'Emigration Same Canton',
                data: $.map(emigrationSameCanton, negate)
            }, {
                name: 'Emigration Other Canton',
                data: $.map(emigrationOtherCanton, negate)
            }, {
                name: 'Migration Balance',
                type: 'spline',
                dashStyle: 'shortdot',
                color: '#DC0018',
                data: migrationBalance
            }]
        });
    }

    function ageGroupDiagram(elem, data) {
        function ageGroupsAsArray(record) {
          return [
            record.population_5_9_years,
            record.population_10_14_years,
            record.population_15_19_years,
            record.population_20_24_years,
            record.population_25_29_years,
            record.population_30_34_years,
            record.population_35_39_years,
            record.population_40_44_years,
            record.population_45_49_years,
            record.population_50_54_years,
            record.population_55_59_years,
            record.population_60_64_years,
            record.population_65_69_years,
            record.population_70_74_years,
            record.population_75_79_years,
            record.population_80_84_years,
            record.population_85_89_years,
            record.population_90_94_years,
            record.population_95_99_years,
            record.population_100_years_or_older
          ];
        }

        function filterSex(constraint) {
            return function(r) {
                return r.sex === constraint;
            }
        }

        var maleAgeGroup = $.map(data.population_by_age_groups.filter(filterSex('male')), ageGroupsAsArray);
        var femaleAgeGroup = $.map(data.population_by_age_groups.filter(filterSex('female')), ageGroupsAsArray);

        var ageGroups = [
          '0-4', '5-9', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40-44', '45-49', '50-54',
          '55-59', '60-64', '65-69', '70-74', '75-79', '80-84', '85-89', '90-94', '95-99', '100+'
        ];

        $(elem).highcharts({
            chart: { type: 'bar' },
            title: { text: 'Age Groups' },
            xAxis: [{
                categories: ageGroups,
                reversed: false,
                labels: { step: 1 }
            }, { // mirror axis on right side
                opposite: true,
                reversed: false,
                categories: ageGroups,
                linkedTo: 0,
                labels: { step: 1 }
            }],
            tooltip: {
              formatter: function () {
                  return '<b>' + this.series.name + ', age ' + this.point.category + '</b><br/>' +
                      'Population: ' + Highcharts.numberFormat(Math.abs(this.point.y), 0);
              }
            },
            yAxis: {
                title: { text: null }
            },
            plotOptions: {
                series: { stacking: 'normal' }
            },
            series: [{
                name: 'Male',
                data: maleAgeGroup
            }, {
                name: 'Female',
                data: $.map(femaleAgeGroup, negate)
            }]
        });
    }

    function flatsByRoomsDiagram(elem, data) {
        function getFlats(r) {
            return r.flats;
        }

        function filterRooms(constraint) {
            return function(r) {
                return r.rooms === constraint;
            }
        }

        var flats = data.flats_by_rooms;
        var years = $.unique($.map(flats, function(r) { return r.year; }));
        var oneRoom = $.map(flats.filter(filterRooms('1')), getFlats);
        var twoRooms = $.map(flats.filter(filterRooms('2')), getFlats);
        var threeRooms = $.map(flats.filter(filterRooms('3')), getFlats);
        var fourRooms = $.map(flats.filter(filterRooms('4')), getFlats);
        var fiveRooms = $.map(flats.filter(filterRooms('5')), getFlats);
        var sixOrMoreRooms = $.map(flats.filter(filterRooms('6+')), getFlats);

        $(elem).highcharts({
            chart: { type: 'area' },
            title: { text: 'Flats' },
            xAxis: { categories: years },
            yAxis: {
                title: { text: 'Wohnungen' }
            },
            plotOptions: {
                area: { stacking: 'normal' }
            },
            series: [{
                name: '1',
                data: oneRoom
            }, {
                name: '2',
                data: twoRooms
            }, {
                name: '3',
                data: threeRooms
            }, {
                name: '4',
                data: fourRooms
            }, {
                name: '5',
                data: fiveRooms
            }, {
                name: '6+',
                data: sixOrMoreRooms
            }]
        });
    }

    function buildingInvestmentsDiagram(elem, data) {

        function extractAmount(category) {
            var investments = data.building_investments_by_category
                .filter(function(r) { return r.category === category; });
            return $.map(investments, function(r) { return r.amount; });
        }

        var years = $.unique($.map(data.building_investments_by_category, function(r) { return r.year; }));

        $(elem).highcharts({
            chart: { type: 'column' },
            title: { text: 'Building Investments' },
            xAxis: { categories: years },
            yAxis: {
                title: { text: 'CHF' }
            },
            plotOptions: {
                series: { stacking: 'normal' }
            },
            series: [{
                name: 'Gesundheit',
                data: extractAmount('Gesundheit'),
            }, {
                name: 'Bildung, Forschung',
                data: extractAmount('Bildung, Forschung'),
            }, {
                name: 'Wohnen',
                data: extractAmount('Wohnen'),
            }, {
                name: 'Infrastruktur',
                data: extractAmount('Infrastruktur'),
            }, {
                name: 'Freizeit, Kultur',
                data: extractAmount('Freizeit, Kultur'),
            }, {
                name: 'Industrie, Gewerbe, Dienstleistungen',
                data: extractAmount('Industrie, Gewerbe, Dienstleistungen'),
            }, {
                name: 'Land- und Forstwirtschaft',
                data: extractAmount('Land- und Forstwirtschaft'),
            }]
        });
    }

    function populationOriginDiagram(elem, data) {
        function getPeople(r) {
            return r.people;
        }

        var foreignBirths= $.map(data.population_birth_place_abroad, getPeople);
        var swissBirths = $.map(data.population_birth_place_switzerland, getPeople);
        var years = $.map(data.population_birth_place_abroad, function(r) { return r.year; });

        $(elem).highcharts({
            chart: { type: 'column' },
            title: { text: 'Herkunft' },
            xAxis: { categories: years },
            yAxis: {
                title: { text: 'People' }
            },
            plotOptions: {
                series: { stacking: 'normal' }
            },
            series: [{
                name: 'Schweiz',
                data: swissBirths
            }, {
                name: 'Ausland',
                data: foreignBirths
            }]
        });
    }

    function workSectorDiagram(elem, data) {
        function getWorkers(r) { return r.workers; }
        function getWorkplaces(r) { return r.workplaces; }
        function filterSector(sector) {
            return function(r) {
                return r.sector === sector;
            }
        }

        var workplaces = data.workplaces_by_sector;
        var primarySectorWorkers = $.map(workplaces.filter(filterSector(1)), getWorkers);
        var secondarySectorWorkers = $.map(workplaces.filter(filterSector(2)), getWorkers);
        var tertiarySectorWorkers = $.map(workplaces.filter(filterSector(3)), getWorkers);

        var primarySectorWorkplaces = $.map(workplaces.filter(filterSector(1)), getWorkplaces);
        var secondarySectorWorkplaces = $.map(workplaces.filter(filterSector(2)), getWorkplaces);
        var tertiarySectorWorkplaces = $.map(workplaces.filter(filterSector(3)), getWorkplaces);

        $(elem).highcharts({
            chart: { type: 'pie' },
            title: { text: 'Workplaces by Sector' },
            plotOptions: {
                pie: {
                  shadow: false,
                  center: ['50%', '50%']
                }
            },
            series: [{
              name: 'Betriebe',
              size: '60%',
              data: [{
                name: 'Betriebe 1. Sektor',
                y: primarySectorWorkplaces[0]
              }, {
                name: 'Betriebe 2. Sektor',
                y: secondarySectorWorkplaces[0]
              }, {
                name: 'Betriebe 3. Sektor',
                y: tertiarySectorWorkplaces[0]
              }]
            }, {
              name: 'Arbeitsplätze',
              size: '80%',
              innerSize: '60%',
              data: [{
                name: 'Arbeitsplätze 1. Sektor',
                y: primarySectorWorkers[0]
              }, {
                name: 'Arbeitsplätze 2. Sektor',
                y: secondarySectorWorkers[0]
              }, {
                name: 'Arbeitsplätze 3. Sektor',
                y: tertiarySectorWorkers[0]
              }]
            }]
        });
    }

    function workSizeDiagram(elem, data) {
        function getWorkers(r) { return r.workers; }
        function getWorkplaces(r) { return r.workplaces; }
        function filterSize(size) {
            return function(r) {
                return r.workplace_size === size;
            }
        }

        var workplaces = data.workplaces_by_size;

        var microWorkers = $.map(workplaces.filter(filterSize('micro')), getWorkers);
        var smallWorkers = $.map(workplaces.filter(filterSize('small')), getWorkers);
        var mediumWorkers = $.map(workplaces.filter(filterSize('medium')), getWorkers);
        var bigWorkers = $.map(workplaces.filter(filterSize('big')), getWorkers);

        var microWorkplaces = $.map(workplaces.filter(filterSize('micro')), getWorkplaces);
        var smallWorkplaces = $.map(workplaces.filter(filterSize('small')), getWorkplaces);
        var mediumWorkplaces = $.map(workplaces.filter(filterSize('medium')), getWorkplaces);
        var bigWorkplaces = $.map(workplaces.filter(filterSize('big')), getWorkplaces);

        $(elem).highcharts({
            chart: { type: 'pie' },
            title: { text: 'Workplaces by Size' },
            plotOptions: {
                pie: {
                  shadow: false,
                  center: ['50%', '50%']
                }
            },
            series: [{
              name: 'Betriebe',
              size: '60%',
              data: [{
                name: 'Mikrounternehmen',
                y: microWorkplaces[0]
              }, {
                name: 'Kleinunternehmen',
                y: smallWorkplaces[0]
              }, {
                name: 'Mittlere Unternehmen',
                y: mediumWorkplaces[0]
              }, {
                name: 'Grossunternehmen',
                y: bigWorkplaces[0]
              }]
            }, {
              name: 'Arbeitsplätze',
              size: '80%',
              innerSize: '60%',
              data: [{
                name: 'Mikrounternehmen',
                y: microWorkers[0]
              }, {
                name: 'Kleinunternehmen',
                y: smallWorkers[0]
              }, {
                name: 'Mittlere Unternehmen',
                y: mediumWorkers[0]
              }, {
                name: 'Grossunternehmen',
                y: bigWorkers[0]
              }]
            }]
        });
    }

    var baseUrl = 'http://192.168.99.100:3000';

    function loadDiagrams(communityId) {
        $.get(baseUrl + '/communities/' + communityId, function(data) {
            populationOriginDiagram($('#population-origin-diagram'), data);
            birthDeathDiagram($('#birth-death-diagram'), data);
            ageGroupDiagram($('#age-group-diagram'), data);
            workSectorDiagram($('#work-sector-diagram'), data);
            workSizeDiagram($('#work-size-diagram'), data);
            migrationDiagram($('#migration-diagram'), data);
            partyShareDiagram($('#party-share-diagram'), data);
            buildingInvestmentsDiagram($('#building-investments-diagram'), data);
            flatsByRoomsDiagram($('#flats-rooms-diagram'), data);
        });
    }

    $('#search-form').submit(function(e) {
        var query = $('#search-query').val();
        e.preventDefault();
        $.get(baseUrl + '/communities?q=' + query, function(results) {
            var community = results[0];
            loadDiagrams(community.id);
            $('#community-name').text(community.name);
        });
    });

    $("#search-query").easyAutocomplete({
        url: baseUrl + '/communities',
        getValue: "name",
        list: {
            match: { enabled: true }
         },
    });

    loadDiagrams(261);
});
